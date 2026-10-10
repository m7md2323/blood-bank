using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "smart_blood_bank");

            migrationBuilder.CreateTable(
                name: "blood_banks",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    name = table.Column<string>(type: "text", nullable: false),
                    email = table.Column<string>(type: "text", nullable: false),
                    location_city = table.Column<string>(type: "text", nullable: false),
                    location_latitude = table.Column<double>(type: "double precision", nullable: false),
                    location_longitude = table.Column<double>(type: "double precision", nullable: false),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_blood_banks", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "hospitals",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    name = table.Column<string>(type: "text", nullable: false),
                    email = table.Column<string>(type: "text", nullable: false),
                    phone_number = table.Column<string>(type: "text", nullable: false),
                    location_city = table.Column<string>(type: "text", nullable: false),
                    location_latitude = table.Column<double>(type: "double precision", nullable: false),
                    location_longitude = table.Column<double>(type: "double precision", nullable: false),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_hospitals", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "donation_campaigns",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    blood_bank_id = table.Column<Guid>(type: "uuid", nullable: false),
                    blood_type = table.Column<int>(type: "integer", nullable: false),
                    title = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: false),
                    target_units = table.Column<int>(type: "integer", nullable: false),
                    start_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    end_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    status = table.Column<int>(type: "integer", nullable: false),
                    actual_units = table.Column<int>(type: "integer", nullable: false),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_donation_campaigns", x => x.id);
                    table.ForeignKey(
                        name: "FK_donation_campaigns_blood_banks_blood_bank_id",
                        column: x => x.blood_bank_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_banks",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "blood_requests",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    blood_type = table.Column<int>(type: "integer", nullable: false),
                    number_of_units = table.Column<int>(type: "integer", nullable: false),
                    urgency_level = table.Column<int>(type: "integer", nullable: false),
                    status = table.Column<int>(type: "integer", nullable: false),
                    component_type = table.Column<int>(type: "integer", nullable: false),
                    hospital_id = table.Column<Guid>(type: "uuid", nullable: false),
                    blood_bank_id = table.Column<Guid>(type: "uuid", nullable: true),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_blood_requests", x => x.id);
                    table.ForeignKey(
                        name: "FK_blood_requests_blood_banks_blood_bank_id",
                        column: x => x.blood_bank_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_banks",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_blood_requests_hospitals_hospital_id",
                        column: x => x.hospital_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "hospitals",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "users",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    national_number = table.Column<string>(type: "text", nullable: false),
                    full_name = table.Column<string>(type: "text", nullable: false),
                    gender = table.Column<int>(type: "integer", nullable: false),
                    email = table.Column<string>(type: "text", nullable: false),
                    phone_number = table.Column<string>(type: "text", nullable: false),
                    password_hash = table.Column<string>(type: "text", nullable: false),
                    date_of_birth = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    blood_type = table.Column<int>(type: "integer", nullable: false),
                    status = table.Column<int>(type: "integer", nullable: false),
                    role = table.Column<int>(type: "integer", nullable: false),
                    blood_units_balance = table.Column<int>(type: "integer", nullable: false),
                    is_deleted = table.Column<bool>(type: "boolean", nullable: false),
                    hospital_id = table.Column<Guid>(type: "uuid", nullable: true),
                    blood_bank_id = table.Column<Guid>(type: "uuid", nullable: true),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false),
                    location_city = table.Column<string>(type: "text", nullable: false),
                    location_latitude = table.Column<double>(type: "double precision", nullable: false),
                    location_longitude = table.Column<double>(type: "double precision", nullable: false),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.id);
                    table.ForeignKey(
                        name: "FK_users_blood_banks_blood_bank_id",
                        column: x => x.blood_bank_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_banks",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_users_hospitals_hospital_id",
                        column: x => x.hospital_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "hospitals",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "blood_units",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    is_deleted = table.Column<bool>(type: "boolean", nullable: false),
                    blood_type = table.Column<int>(type: "integer", nullable: false),
                    component_type = table.Column<int>(type: "integer", nullable: false),
                    volume_ml = table.Column<double>(type: "double precision", nullable: false),
                    collection_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    expiration_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    status = table.Column<int>(type: "integer", nullable: false),
                    donor_id = table.Column<Guid>(type: "uuid", nullable: false),
                    recipient_acceptor_id = table.Column<Guid>(type: "uuid", nullable: true),
                    current_hospital_id = table.Column<Guid>(type: "uuid", nullable: true),
                    current_blood_bank_id = table.Column<Guid>(type: "uuid", nullable: true),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_blood_units", x => x.id);
                    table.ForeignKey(
                        name: "FK_blood_units_blood_banks_current_blood_bank_id",
                        column: x => x.current_blood_bank_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_banks",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_blood_units_hospitals_current_hospital_id",
                        column: x => x.current_hospital_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "hospitals",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_blood_units_users_donor_id",
                        column: x => x.donor_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_blood_units_users_recipient_acceptor_id",
                        column: x => x.recipient_acceptor_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "donation_appointments",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    user_id = table.Column<Guid>(type: "uuid", nullable: false),
                    blood_bank_id = table.Column<Guid>(type: "uuid", nullable: false),
                    scheduled_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    status = table.Column<int>(type: "integer", nullable: false),
                    notes = table.Column<string>(type: "text", nullable: true),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_donation_appointments", x => x.id);
                    table.ForeignKey(
                        name: "FK_donation_appointments_blood_banks_blood_bank_id",
                        column: x => x.blood_bank_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_banks",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_donation_appointments_users_user_id",
                        column: x => x.user_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "notifications",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    title = table.Column<string>(type: "text", nullable: false),
                    message = table.Column<string>(type: "text", nullable: false),
                    is_read = table.Column<bool>(type: "boolean", nullable: false),
                    read_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    recipient_user_id = table.Column<Guid>(type: "uuid", nullable: true),
                    recipient_hospital_id = table.Column<Guid>(type: "uuid", nullable: true),
                    recipient_blood_bank_id = table.Column<Guid>(type: "uuid", nullable: true),
                    related_blood_request_id = table.Column<Guid>(type: "uuid", nullable: true),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_notifications", x => x.id);
                    table.ForeignKey(
                        name: "FK_notifications_blood_banks_recipient_blood_bank_id",
                        column: x => x.recipient_blood_bank_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_banks",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_notifications_blood_requests_related_blood_request_id",
                        column: x => x.related_blood_request_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_requests",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_notifications_hospitals_recipient_hospital_id",
                        column: x => x.recipient_hospital_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "hospitals",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_notifications_users_recipient_user_id",
                        column: x => x.recipient_user_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "users",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "donations",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    donor_id = table.Column<Guid>(type: "uuid", nullable: false),
                    hospital_id = table.Column<Guid>(type: "uuid", nullable: true),
                    blood_bank_id = table.Column<Guid>(type: "uuid", nullable: true),
                    blood_unit_id = table.Column<Guid>(type: "uuid", nullable: false),
                    donation_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    next_eligible_donation_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_donations", x => x.id);
                    table.ForeignKey(
                        name: "FK_donations_blood_banks_blood_bank_id",
                        column: x => x.blood_bank_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_banks",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_donations_blood_units_blood_unit_id",
                        column: x => x.blood_unit_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_units",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_donations_hospitals_hospital_id",
                        column: x => x.hospital_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "hospitals",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_donations_users_donor_id",
                        column: x => x.donor_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "wallet_transactions",
                schema: "smart_blood_bank",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    user_id = table.Column<Guid>(type: "uuid", nullable: false),
                    amount = table.Column<int>(type: "integer", nullable: false),
                    receiver_id = table.Column<Guid>(type: "uuid", nullable: false),
                    donation_id = table.Column<Guid>(type: "uuid", nullable: false),
                    blood_request_id = table.Column<Guid>(type: "uuid", nullable: true),
                    created_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at_utc = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_wallet_transactions", x => x.id);
                    table.ForeignKey(
                        name: "FK_wallet_transactions_blood_requests_blood_request_id",
                        column: x => x.blood_request_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "blood_requests",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_wallet_transactions_donations_donation_id",
                        column: x => x.donation_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "donations",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_wallet_transactions_users_receiver_id",
                        column: x => x.receiver_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_wallet_transactions_users_user_id",
                        column: x => x.user_id,
                        principalSchema: "smart_blood_bank",
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_blood_requests_blood_bank_id",
                schema: "smart_blood_bank",
                table: "blood_requests",
                column: "blood_bank_id");

            migrationBuilder.CreateIndex(
                name: "IX_blood_requests_hospital_id",
                schema: "smart_blood_bank",
                table: "blood_requests",
                column: "hospital_id");

            migrationBuilder.CreateIndex(
                name: "IX_blood_units_current_blood_bank_id",
                schema: "smart_blood_bank",
                table: "blood_units",
                column: "current_blood_bank_id");

            migrationBuilder.CreateIndex(
                name: "IX_blood_units_current_hospital_id",
                schema: "smart_blood_bank",
                table: "blood_units",
                column: "current_hospital_id");

            migrationBuilder.CreateIndex(
                name: "IX_blood_units_donor_id",
                schema: "smart_blood_bank",
                table: "blood_units",
                column: "donor_id");

            migrationBuilder.CreateIndex(
                name: "IX_blood_units_recipient_acceptor_id",
                schema: "smart_blood_bank",
                table: "blood_units",
                column: "recipient_acceptor_id");

            migrationBuilder.CreateIndex(
                name: "IX_donation_appointments_blood_bank_id",
                schema: "smart_blood_bank",
                table: "donation_appointments",
                column: "blood_bank_id");

            migrationBuilder.CreateIndex(
                name: "IX_donation_appointments_user_id",
                schema: "smart_blood_bank",
                table: "donation_appointments",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_donation_campaigns_blood_bank_id",
                schema: "smart_blood_bank",
                table: "donation_campaigns",
                column: "blood_bank_id");

            migrationBuilder.CreateIndex(
                name: "IX_donations_blood_bank_id",
                schema: "smart_blood_bank",
                table: "donations",
                column: "blood_bank_id");

            migrationBuilder.CreateIndex(
                name: "IX_donations_blood_unit_id",
                schema: "smart_blood_bank",
                table: "donations",
                column: "blood_unit_id");

            migrationBuilder.CreateIndex(
                name: "IX_donations_donor_id",
                schema: "smart_blood_bank",
                table: "donations",
                column: "donor_id");

            migrationBuilder.CreateIndex(
                name: "IX_donations_hospital_id",
                schema: "smart_blood_bank",
                table: "donations",
                column: "hospital_id");

            migrationBuilder.CreateIndex(
                name: "IX_notifications_recipient_blood_bank_id",
                schema: "smart_blood_bank",
                table: "notifications",
                column: "recipient_blood_bank_id");

            migrationBuilder.CreateIndex(
                name: "IX_notifications_recipient_hospital_id",
                schema: "smart_blood_bank",
                table: "notifications",
                column: "recipient_hospital_id");

            migrationBuilder.CreateIndex(
                name: "IX_notifications_recipient_user_id",
                schema: "smart_blood_bank",
                table: "notifications",
                column: "recipient_user_id");

            migrationBuilder.CreateIndex(
                name: "IX_notifications_related_blood_request_id",
                schema: "smart_blood_bank",
                table: "notifications",
                column: "related_blood_request_id");

            migrationBuilder.CreateIndex(
                name: "IX_users_blood_bank_id",
                schema: "smart_blood_bank",
                table: "users",
                column: "blood_bank_id");

            migrationBuilder.CreateIndex(
                name: "IX_users_hospital_id",
                schema: "smart_blood_bank",
                table: "users",
                column: "hospital_id");

            migrationBuilder.CreateIndex(
                name: "IX_wallet_transactions_blood_request_id",
                schema: "smart_blood_bank",
                table: "wallet_transactions",
                column: "blood_request_id");

            migrationBuilder.CreateIndex(
                name: "IX_wallet_transactions_donation_id",
                schema: "smart_blood_bank",
                table: "wallet_transactions",
                column: "donation_id");

            migrationBuilder.CreateIndex(
                name: "IX_wallet_transactions_receiver_id",
                schema: "smart_blood_bank",
                table: "wallet_transactions",
                column: "receiver_id");

            migrationBuilder.CreateIndex(
                name: "IX_wallet_transactions_user_id",
                schema: "smart_blood_bank",
                table: "wallet_transactions",
                column: "user_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "donation_appointments",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "donation_campaigns",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "notifications",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "wallet_transactions",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "blood_requests",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "donations",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "blood_units",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "users",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "blood_banks",
                schema: "smart_blood_bank");

            migrationBuilder.DropTable(
                name: "hospitals",
                schema: "smart_blood_bank");
        }
    }
}
