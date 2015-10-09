import java.util.*;

Table csv_table;
ArrayList regions;
Region r;
int border=0;

int timeSinceLastLetter;

void setup() 
{
  size(500,500,P3D);
  smooth();
  //noLoop();  
  csv_table = loadTable("data_region_names.csv", "header");
  regions = new ArrayList();
  timeSinceLastLetter = millis();
  // Loop data
  for (TableRow row : csv_table.rows())
  {
     String name = row.getString("name");
     int size = regions.size();
     
     // Loop currently created regions
     for(int i=0; i<=size; i++)
     {
       try{
       r = (Region) regions.get(i);
       
       // Check to see if region is already created, if so add new data
       if(r.name.equals(name))
       {
         String device = row.getString("device"); 
         int hits = row.getInt("sess");
         
          print("--- Additional "+r.name+" data found \n");
         
          if (device.equals("desktop")){                  
               r.desktop_hits = hits;      
               print("- Desktop Hits added to: "+r.name+"\n");}
          else if (device.equals("mobile")){                 
               r.mobile_hits = hits;
               print("- Mobile Hits added to: "+name+"\n");}
          else if (device.equals("tablet")){                 
               r.tablet_hits = hits;
               print("- Tablet Hits added to: "+name+"\n");}
            
         break;
        }
      }
      // Region does not exists, create new one region
      catch(IndexOutOfBoundsException e)
      {
        if (i==size) 
        {
        float lat = row.getInt("lat");
        float lon = row.getInt("lon");
        String device = row.getString("device"); 
        int hits = row.getInt("sess");
        int dhits = 0;
        int mhits = 0;
        int thits = 0;
        
        print("*** Region "+name+" Created"+"\n");
        if (device.equals("desktop")){                  
             dhits = hits;      
             print("* Desktop Hits added to: "+name+"\n");}
        else if (device.equals("mobile")){                 
             mhits = hits;
             print("* Mobile Hits added to: "+name+"\n");}
        else if (device.equals("tablet")){                 
             thits = hits;
             print("* Tablet Hits added to: "+name+"\n");}
         
        regions.add(new Region(name,lon,lat,dhits,mhits,hits));
      
        }
      }
    }
  } 
 print(">> DONE");
 
 // Print Region Data
 //for(int i=0; i<regions.size(); i++){
 //   r = (Region) regions.get(i);
 //   print("\n Name: "+r.name+" DESKTOP: "+r.desktop_hits+ " MOBILE: "+r.mobile_hits+ " TABLET: "+r.tablet_hits+"\n");
 //   print(r.hitRatio());  
 //}
}

class Region
{  
  String name;
  float lon;
  float lat;
  int desktop_hits = 0;
  int mobile_hits  = 0;
  int tablet_hits  = 0;
  
  //Constructor
  Region(String tname , float tlon, float tlat, int desk, int mobile, int tab )
  {
    name = tname;
    lon  = tlon;
    lat  = tlat;
    desktop_hits = desktop_hits + desk;
    mobile_hits  = mobile_hits  + mobile;
    tablet_hits  = tablet_hits  + tab;
  }

   public float hitRatio()
  {
   float cHits = mobile_hits+tablet_hits;
   float total = cHits+desktop_hits;
   
   float dRatio = desktop_hits/total; 
   //if (cHits<=desktop_hits){dRatio = cHits/total;} 
   
   float nColor = 255*dRatio;
   
   return(nColor);
   
  }
}

void draw()
{ 
  textSize(32);
  //println(timeSinceLastLetter);
  for(int i=0; i<border; i++){
    r = (Region) regions.get(i);

   // if (r.name.equals("Saga Prefecture")){ 
     //  print(r.hitRatio());
       background(r.hitRatio(), 127, 200); 
       text(r.name, 10, 30); 
       text("Pink = Desktop", 10, 300);
       text("Blue = Mobile", 10, 200);
   //  }
   }
   // delay counter for asset cycle
  if (millis ()- timeSinceLastLetter >= 100) {
   timeSinceLastLetter = millis();
   border++;
   if (border>regions.size()){border =regions.size();}
  }
}


