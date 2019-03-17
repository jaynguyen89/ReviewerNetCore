using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace ReviewerNet.Models
{
    public partial class MainApiDbContext : DbContext
    {
        public MainApiDbContext()
        {
        }

        public MainApiDbContext(DbContextOptions<MainApiDbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Blockings> Blockings { get; set; }
        public virtual DbSet<Locations> Locations { get; set; }
        public virtual DbSet<Profiles> Profiles { get; set; }
        public virtual DbSet<UserConnections> UserConnections { get; set; }
        public virtual DbSet<Users> Users { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Server=.\\SQLEXPRESS;Database=MainApiDb;Trusted_Connection=True");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.3-servicing-35854");

            modelBuilder.Entity<Blockings>(entity =>
            {
                entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Blocked)
                    .WithMany(p => p.BlockingsBlocked)
                    .HasForeignKey(d => d.BlockedId)
                    .OnDelete(DeleteBehavior.ClientSetNull);

                entity.HasOne(d => d.Blocker)
                    .WithMany(p => p.BlockingsBlocker)
                    .HasForeignKey(d => d.BlockerId)
                    .OnDelete(DeleteBehavior.ClientSetNull);
            });

            modelBuilder.Entity<Locations>(entity =>
            {
                entity.Property(e => e.AvatarName).HasMaxLength(450);

                entity.Property(e => e.BuildingAddress).HasMaxLength(50);

                entity.Property(e => e.BuildingName).HasMaxLength(50);

                entity.Property(e => e.CityDistrict)
                    .HasColumnName("City_District")
                    .HasMaxLength(50);

                entity.Property(e => e.CombinedAddress).HasMaxLength(450);

                entity.Property(e => e.Country).HasMaxLength(50);

                entity.Property(e => e.CountryCode).HasMaxLength(10);

                entity.Property(e => e.Description).HasMaxLength(200);

                entity.Property(e => e.FormerAddress).HasMaxLength(150);

                entity.Property(e => e.Postcode).HasMaxLength(10);

                entity.Property(e => e.ProvinceState)
                    .HasColumnName("Province_State")
                    .HasMaxLength(50);

                entity.Property(e => e.SimpleAddress).HasMaxLength(200);

                entity.Property(e => e.StreetAddress).HasMaxLength(50);

                entity.Property(e => e.SuburbWard)
                    .HasColumnName("Suburb_Ward")
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<Profiles>(entity =>
            {
                entity.Property(e => e.AvatarName).HasMaxLength(450);

                entity.Property(e => e.AvatarTitle).HasMaxLength(100);

                entity.Property(e => e.BlogLink).HasMaxLength(200);

                entity.Property(e => e.CauseOfDeath).HasMaxLength(100);

                entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Education).HasMaxLength(4000);

                entity.Property(e => e.FacebookProfile).HasMaxLength(200);

                entity.Property(e => e.FavoriteQuotes).HasMaxLength(1000);

                entity.Property(e => e.FirstName).HasMaxLength(50);

                entity.Property(e => e.GiveName).HasMaxLength(50);

                entity.Property(e => e.HighLights).HasMaxLength(4000);

                entity.Property(e => e.IsUserProfile).HasDefaultValueSql("((0))");

                entity.Property(e => e.Languages).HasMaxLength(1000);

                entity.Property(e => e.MiddleName).HasMaxLength(50);

                entity.Property(e => e.Occupations).HasMaxLength(1000);

                entity.Property(e => e.OtherNames).HasMaxLength(1000);

                entity.Property(e => e.ParentsName).HasMaxLength(150);

                entity.Property(e => e.PhoneNumber).HasMaxLength(30);

                entity.Property(e => e.PlacesOfLiving).HasMaxLength(4000);

                entity.Property(e => e.PobLocationId).HasColumnName("POB_LocationId");

                entity.Property(e => e.PodLocationId).HasColumnName("POD_LocationId");

                entity.Property(e => e.ProfileContent).HasMaxLength(4000);

                entity.Property(e => e.Relationships).HasMaxLength(4000);

                entity.Property(e => e.TwitterProfile).HasMaxLength(200);

                entity.Property(e => e.UpdateRecords).HasMaxLength(4000);

                entity.Property(e => e.WorkHistory).HasMaxLength(4000);

                entity.HasOne(d => d.PobLocation)
                    .WithMany(p => p.ProfilesPobLocation)
                    .HasForeignKey(d => d.PobLocationId)
                    .HasConstraintName("FK_Profiles_Locations_POB");

                entity.HasOne(d => d.PodLocation)
                    .WithMany(p => p.ProfilesPodLocation)
                    .HasForeignKey(d => d.PodLocationId)
                    .HasConstraintName("FK_Profiles_Locations_POD");

                entity.HasOne(d => d.RestingPlace)
                    .WithMany(p => p.ProfilesRestingPlace)
                    .HasForeignKey(d => d.RestingPlaceId)
                    .HasConstraintName("FK_Profiles_Locations_RIP");
            });

            modelBuilder.Entity<UserConnections>(entity =>
            {
                entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.IsAccepted).HasDefaultValueSql("((0))");

                entity.Property(e => e.Message).HasMaxLength(250);

                entity.HasOne(d => d.Receiver)
                    .WithMany(p => p.UserConnectionsReceiver)
                    .HasForeignKey(d => d.ReceiverId)
                    .OnDelete(DeleteBehavior.ClientSetNull);

                entity.HasOne(d => d.Requester)
                    .WithMany(p => p.UserConnectionsRequester)
                    .HasForeignKey(d => d.RequesterId)
                    .OnDelete(DeleteBehavior.ClientSetNull);
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.Property(e => e.AvatarName).HasMaxLength(450);

                entity.Property(e => e.ConfirmToken).HasMaxLength(450);

                entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.FamilyName).HasMaxLength(50);

                entity.Property(e => e.GiveName).HasMaxLength(50);

                entity.Property(e => e.Headline).HasMaxLength(150);

                entity.Property(e => e.Is2Faenabled)
                    .HasColumnName("Is2FAEnabled")
                    .HasDefaultValueSql("((0))");

                entity.Property(e => e.IsActive).HasDefaultValueSql("((1))");

                entity.Property(e => e.IsEmailConfirmed).HasDefaultValueSql("((0))");

                entity.Property(e => e.IsPhoneComfirmed).HasDefaultValueSql("((0))");

                entity.Property(e => e.MiddleName).HasMaxLength(50);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(450);

                entity.Property(e => e.PhoneNumber).HasMaxLength(30);

                entity.Property(e => e.TempPassword).HasMaxLength(450);

                entity.Property(e => e.TwoFadestination)
                    .HasColumnName("TwoFADestination")
                    .HasDefaultValueSql("((0))");

                entity.Property(e => e.TwoFatoken)
                    .HasColumnName("TwoFAToken")
                    .HasMaxLength(450);

                entity.Property(e => e.TwoFatokenSentOn).HasColumnName("TwoFATokenSentOn");

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasMaxLength(30);

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.Users)
                    .HasForeignKey(d => d.LocationId)
                    .HasConstraintName("FK_Users_Locations");

                entity.HasOne(d => d.Profile)
                    .WithMany(p => p.Users)
                    .HasForeignKey(d => d.ProfileId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Users_Profiles");
            });
        }
    }
}
