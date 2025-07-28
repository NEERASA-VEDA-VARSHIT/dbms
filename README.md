# Event Management JDBC System

A comprehensive Java-based Event Management System that uses JDBC to interact with a MySQL database. The system provides complete event management capabilities including session management, speaker tracking, user registration, and comprehensive reporting.

## 🚀 Features

### Core Functionalities
- **Session Capacity Management**: Track sessions at capacity and waitlist counts
- **Revenue Analysis**: Detailed revenue breakdown by ticket category
- **Speaker Analytics**: Attendee counts per speaker
- **Discount Code Tracking**: Usage rates and limits for promotional codes
- **Feedback Analysis**: Average session feedback scores
- **User Session Records**: Track sessions attended by specific users

### Database Features
- **15 Tables**: Complete relational database schema
- **Sample Data**: Comprehensive test data for all scenarios
- **Automatic Setup**: Database initialization included
- **Connection Management**: Robust database connection handling

## 📋 Prerequisites

- **Java 8 or higher**
- **MySQL Server 5.7 or higher**
- **Maven 3.6 or higher** (for building)

## 🛠️ Installation & Setup

### 1. Database Setup

1. **Install MySQL Server** if not already installed
2. **Create the database**:
   ```sql
   CREATE DATABASE event_management;
   ```
3. **Configure database credentials** in `src/database/DBUtil.java`:
   ```java
   private static final String USER = "your_username";
   private static final String PASSWORD = "your_password";
   ```

### 2. Build the Application

#### Option A: Using Maven (Recommended)
```bash
# Clone the repository
git clone <your-repo-url>
cd EventManagementJDBC

# Build the JAR file
mvn clean package
```

#### Option B: Using provided scripts
```bash
# Windows
build.bat

# Linux/Mac
./build.sh
```

### 3. Run the Application

#### Option A: Using the JAR file
```bash
java -jar target/event-management-jdbc-1.0.0.jar
```

#### Option B: Using provided scripts
```bash
# Windows
java -jar target/event-management-jdbc-1.0.0.jar

# Linux/Mac
java -jar target/event-management-jdbc-1.0.0.jar
```

## 📊 Available Reports

The application provides an interactive menu with the following reports:

1. **Sessions at Capacity and Waitlisted Counts**
   - Shows sessions that have reached capacity
   - Displays waitlist counts for oversubscribed sessions
   - Helps with capacity planning

2. **Revenue by Ticket Category**
   - Breakdown of revenue by ticket type
   - Total tickets sold per category
   - Revenue analysis for business insights

3. **Attendee Counts per Speaker**
   - Number of attendees per speaker
   - Speaker popularity analysis
   - Session attendance tracking

4. **Discount Code Usage Rates**
   - Usage statistics for promotional codes
   - Percentage of usage vs. limits
   - Marketing effectiveness analysis

5. **Average Session Feedback Scores**
   - Average ratings for each session
   - Session quality assessment
   - Speaker performance metrics

6. **Record of Sessions Attended by a User**
   - Individual user session history
   - Attendance tracking
   - User engagement analysis

## 🗄️ Database Schema

### Core Tables
- **venue**: Event venues with capacity information
- **event**: Main events with dates and descriptions
- **session**: Individual sessions within events
- **speaker**: Session speakers with bio and contact info
- **Users**: Event attendees and participants
- **ticket_type**: Different ticket categories and pricing
- **discount_code**: Promotional codes and usage limits
- **registration**: User registrations with payment info
- **session_enrollment**: Session attendance tracking
- **feedback**: Session ratings and comments

### Supporting Tables
- **Company**: Sponsor companies
- **sponsorers_package**: Sponsorship packages
- **sponsorship**: Sponsor registrations
- **exhibitor_allocation**: Booth assignments
- **session_speaker**: Many-to-many relationship between sessions and speakers

## 📁 Project Structure

```
EventManagementJDBC/
├── target/
│   └── event-management-jdbc-1.0.0.jar    # JAR FILE
├── src/
│   ├── database/
│   │   ├── DBUtil.java                     # Database connection utility
│   │   └── DatabaseSetup.java              # Database initialization
│   ├── dao/
│   │   └── ReportDAO.java                  # Data Access Object for reports
│   ├── model/                              # Data model classes
│   │   ├── SessionCapacityInfo.java
│   │   ├── TicketRevenue.java
│   │   ├── SpeakerAttendeeCount.java
│   │   ├── DiscountCodeUsage.java
│   │   ├── SessionFeedbackScore.java
│   │   └── UserSessionRecord.java
│   ├── EventManager.java                   # Main application class
│   └── DBtest.java                        # Test file (not needed for submission)
├── sql/
│   └── schema.sql                          # Database schema and sample data
├── lib/
│   └── mysql-connector-j-9.3.0.jar        # MySQL JDBC driver
├── pom.xml                                 # Maven configuration
├── build.bat                               # Windows build script
├── build.sh                                # Linux/Mac build script
├── compile.bat                             # Windows compilation script
├── compile.sh                              # Linux/Mac compilation script
├── run.bat                                 # Windows execution script
├── run.sh                                  # Linux/Mac execution script
├── manifest.txt                            # JAR manifest
├── README.md                               # This file
└── PROJECT_SUMMARY.md                     # Project summary
```

## 🔧 Configuration

### Database Configuration
Edit `src/database/DBUtil.java` to match your MySQL setup:

```java
private static final String URL = "jdbc:mysql://localhost:3306/event_management";
private static final String USER = "your_username";
private static final String PASSWORD = "your_password";
```

### Default Database Settings
- **Host**: localhost
- **Port**: 3306
- **Database**: event_management
- **Username**: root (change as needed)
- **Password**: ##### (change as needed)

## 🎯 Sample Output

When you run the application, you'll see formatted reports like:

```
=== Sessions at Capacity and Waitlisted Counts ===
Session ID  | Title                           | Capacity | Confirmed      | Waitlist    
================================================================================
1           | Introduction to AI              | 100      | 95             | 5          
2           | Machine Learning Fundamentals   | 80       | 80             | 2          
3           | Deep Learning Applications      | 60       | 60             | 3          

=== Revenue by Ticket Category ===
Ticket Type         | Total Revenue    | Tickets Sold
==================================================
Early Bird          | $299.00          | 3           
Regular             | $1,118.45        | 3           
Premium             | $1,498.50        | 3           
VIP                 | $899.00          | 1           
--------------------------------------------------
TOTAL               | $3,814.95        | 10          
```

## 🚀 Quick Start

1. **Setup Database**:
   ```bash
   mysql -u root -p
   CREATE DATABASE event_management;
   ```

2. **Build and Run**:
   ```bash
   # Option A: Using build scripts
   build.bat          # Windows
   ./build.sh         # Linux/Mac
   
   # Option B: Using Maven
   mvn clean package
   
   # Run the application
   java -jar target/event-management-jdbc-1.0.0.jar
   ```

3. **Follow the Interactive Menu** to explore different reports

## 🧪 Testing

The application includes comprehensive test data:
- **8 Sessions** with varying capacities
- **6 Speakers** with different expertise areas
- **10 Users** with diverse backgrounds
- **4 Ticket Types** with different pricing
- **4 Discount Codes** with usage limits
- **Realistic Capacity Scenarios** with waitlists
- **Feedback Data** for session quality analysis

## 📝 Technical Details

- **Language**: Java 8+
- **Database**: MySQL 5.7+
- **JDBC Driver**: MySQL Connector/J 9.3.0
- **Architecture**: DAO pattern with model classes
- **Build Tools**: Maven or manual build scripts
- **Packaging**: Executable JAR with dependencies
- **Project Structure**: Organized with separate packages for database, DAO, and models

## 🔍 Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Ensure MySQL is running
   - Verify database credentials in `DBUtil.java`
   - Check if database `event_management` exists

2. **JAR File Not Found**
   - Run `mvn clean package` to build
   - Check `target/` directory for the JAR file

3. **Permission Denied (Linux/Mac)**
   - Make scripts executable: `chmod +x *.sh`

4. **Java Version Issues**
   - Ensure Java 8 or higher is installed
   - Check with: `java -version`


For issues or questions:
1. Check the troubleshooting section above
2. Verify database configuration
3. Ensure all prerequisites are met
4. Review the sample data in `sql/schema.sql`



This project demonstrates:
- **JDBC Database Connectivity**
- **Complex SQL Queries**
- **Data Access Object Pattern**
- **Comprehensive Reporting System**
- **Interactive User Interface**
- **Proper Error Handling**
- **Database Schema Design**
- **Sample Data**

