#20220804 get unique facility codes from nei, 2011, texas, formaldehyde
#run inputs and setup sections in 03_harmony.R, then insert this code after reading nei_joined.csv

#get facility IDs for UC Davis folk
qq = nei %>% 
    # mutate(load_kg = as.numeric(EMISSIONS) / 2.2046) %>% # lb to kg
    filter(POLLUTANT_CODE == '50000',
           INVENTORY_YEAR == 2011,
           STATE == 'TX') %>%
    mutate(city = ifelse(COUNTY %in% houston_counties, 'HOUSTON', 'PORT ARTHUR')) %>% 
    # tibble(EIS_FACILITY_ID = c(1, 1, 2, 2, 2, 3, 3), location_set_to_county_centroid = c(F, F, T, F, F, T, T)) %>% 
    group_by(EIS_FACILITY_ID) %>% 
    arrange(location_set_to_county_centroid) %>% 
    filter(row_number() == 1) %>% 
    select(-location_set_to_county_centroid) %>% 
    arrange(COUNTY, EMISSIONS)
# jj = select(qq, POLLUTANT_CODE, INVENTORY_YEAR, SITE_NAME, EMISSIONS, STATE, COUNTY, EIS_FACILITY_ID)
# qq[duplicated(jj) | duplicated(jj, fromLast = T), ] %>% 
#     arrange(STATE, COUNTY, EIS_FACILITY_ID, SOURCE_CODE) %>% View()
write_csv(qq, 'data/nei/nei_houston-portarthur_2011_formaldehyde.csv')
write_lines(sort(unique(qq$EIS_FACILITY_ID)), 'data/nei/unique_EIS_FACILITY_IDs.txt')
write_lines(sort(unique(qq$FACILITY_ID)), 'data/nei/unique_FACILITY_IDs.txt')
write_lines(sort(unique(qq$NAICS_CODE)), 'data/nei/unique_NAIDS_CODEs.txt')
write_lines(sort(unique(qq$SOURCE_CODE)), 'data/nei/unique_SOURCE_CODEs.txt')
