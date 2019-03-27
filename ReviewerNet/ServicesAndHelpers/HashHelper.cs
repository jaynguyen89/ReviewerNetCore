using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;

namespace ReviewerNet.ServicesAndHelpers
{
    public static class HashHelper
    {
        // Generates the hashed password and random salt for user registration
        public static KeyValuePair<string, string> CreateHashedString(string plainText)
        {
            //Generating a random 128 bit salt to hash the plain text
            byte[] salt = new byte[128 / 8];
            using (var generator = RandomNumberGenerator.Create())
            {
                generator.GetBytes(salt);
            }
            
            //Hashing the plain text
            string hash = Convert.ToBase64String(
                KeyDerivation.Pbkdf2(
                    password: plainText,
                    salt: salt,
                    prf: KeyDerivationPrf.HMACSHA1,
                    iterationCount: 1000,
                    numBytesRequested: 256/8
                )
            );

            return new KeyValuePair<string, string>(Convert.ToBase64String(salt), hash);
        }
        
        // Generates a hashed string using a password salt to check password matching
        public static string CreateHashedString(string salt, string plainText)
        {
            //Hashing the plain text
            string hash = Convert.ToBase64String(
                KeyDerivation.Pbkdf2(
                    password: plainText,
                    salt: Convert.FromBase64String(salt),
                    prf: KeyDerivationPrf.HMACSHA1,
                    iterationCount: 1000,
                    numBytesRequested: 256/8
                )
            );

            return hash;
        }
        
        // Generates a random hashed string using one-way MD5 to use for tokens
        public static string Md5Hash(string plainText)
        {
            using (MD5 md5 = MD5.Create())
            {
                //Convert plainText to byte array, then compute hash for it
                byte[] bites = Encoding.ASCII.GetBytes(plainText);
                byte[] hash = md5.ComputeHash(bites);
                
                //Convert the hash from byte array to string
                StringBuilder builder = new StringBuilder();
                foreach (var bite in hash)
                    builder.Append(bite.ToString("X2"));

                return builder.ToString();
            }
        }
    }
}