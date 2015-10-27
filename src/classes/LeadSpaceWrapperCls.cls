public class LeadSpaceWrapperCls {	
	
	public Person person;
	public List<Scores> total_scores;
	public String enrichment_status;
	public Company company;
	public dateTime request_timestamp;
	public string request_id;

	public class Technologies_Z {
		public String confidence_level;
		public String name;
	}

	public class Scores {
		public String profile_name;
		public Score score;
	}

	public class Analytics {
		public List<String> technologies;
		public List<Scores> scores;
		public List<String> job_functions;
	}

	public class Analytics_Z {
		public List<Technologies_Z> technologies;
		public List<Technologies_Z> expertise;
		public List<Scores_Z> scores;
	}

	public class Technologies {
	}


	public class Address {
		public String zipcode;
		public String street;
		public String state;
		public String city;
		public String country;
	}

	public class Score_Z {
		public Double value;
	}

	public class Family_tree {
		public String sic;
		public String phone;
		public String naics;
		public String website;
		public Address address;
		public String ls_id;
		public String name;
		public String type;
		public Revenue revenue;
		public Size size;
	}

	public class Scores_Z {
		public String profile_name;
		public Score_Z score;
	}

	public class Company {
		public String sub_industry;
		public String sic;
		public String phone;
		public String website;
		public String ls_id;
		public String linkedin_profile;
		public List<String> ranking_lists;
		public Analytics_Z analytics;
		public Size size;
		public List<Family_tree> family_tree;
		public String naics;
		public Address address;
		public String description;
		public String name;
		public String industry;
		public List<String> stock_tickers;
		public Revenue revenue;
	}

	public class Score {
		public Decimal value;
	}

	public class Person {
		public String first_name;
		public String phone;
		public String title;
		public String level;
		public String department;
		public String original_email_verification_status;
		public String last_name;
		public String verification_status;
		public String linkedin_profile;
		public Analytics analytics;
		public String verification_source;
	}

	public class Size {
		public String range;
		public Double exact;
	}
	
	public class Revenue {
		public String range;
		public String exact;
	}

	
	public static LeadSpaceWrapperCls parse(String json) {
		return (LeadSpaceWrapperCls) System.JSON.deserialize(json, LeadSpaceWrapperCls.class);
	}
}