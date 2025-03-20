#!/bin/bash

file="address.txt"

# Function to create a new record
create() {
    if [[ ! -f "$file" ]]; then
        touch "$file"
    fi
    echo -e "Name $1\nPhone $2\nEmail $3\n" >> "$file"
    echo "Record added successfully!"
}

# Function to read all records
read_records() {
    if [[ ! -f "$file" || ! -s "$file" ]]; then
        echo "No records found."
    else
        cat "$file"
    fi
}

# Function to search for a record by name
search() {
    if [[ ! -f "$file" || ! -s "$file" ]]; then
        echo "No records found."
        return
    fi

    found=0
    while IFS= read -r line; do
        if [[ "$line" == "name $1" ]]; then
            found=1
            echo "$line"
            read -r phone
            read -r email
            echo "$phone"
            echo "$email"
            echo ""
        fi
    done < "$file"

    if [[ $found -eq 0 ]]; then
        echo "Name not found!"
    fi
}

# Function to update a record by name
update() {
    if [[ ! -f "$file" || ! -s "$file" ]]; then
        echo "No records found."
        return
    fi
    
    temp_file="temp_$file"
    found=0

    while IFS= read -r line; do
        if [[ "$line" == "name $1" ]]; then
            echo -e "name $2\nphone $3\nemail $4\n" >> "$temp_file"
            found=1
            # Skip next two lines (old phone and email)
            read -r
            read -r
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$file"

    if [[ $found -eq 1 ]]; then
        mv "$temp_file" "$file"
        echo "Record updated successfully!"
    else
        echo "Name not found!"
        rm "$temp_file"
    fi
}

# Function to delete a record by name
delete() {
    if [[ ! -f "$file" || ! -s "$file" ]]; then
        echo "No records found."
        return
    fi

    temp_file="temp_$file"
    found=0

    while IFS= read -r line; do
        if [[ "$line" == "name $1" ]]; then
            found=1
            # Skip next two lines (phone and email)
            read -r
            read -r
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$file"

    if [[ $found -eq 1 ]]; then
        mv "$temp_file" "$file"
        echo "Record deleted successfully!"
    else
        echo "Name not found!"
        rm "$temp_file"
    fi
}

# User Menu
while true; do
    echo -e "\nChoose an operation:"
    echo "1. Create"
    echo "2. Read"
    echo "3. Update"
    echo "4. Delete"
    echo "5. Search"
    echo "6. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) 
            read -p "Enter name: " Name
            read -p "Enter phone: " Phone
            read -p "Enter email: " Email
            create "$Name" "$Phone" "$Email"
            ;;
        2) read_records ;;
        3) 
            read -p "Enter name to update: " old_name
            read -p "Enter new name: " new_name
            read -p "Enter new phone: " new_phone
            read -p "Enter new email: " new_email
            update "$old_name" "$new_name" "$new_phone" "$new_email"
            ;;
        4) 
            read -p "Enter name to delete: " del_name
            delete "$del_name"
            ;;
        5)
            read -p "Enter name to search: " search_name
            search "$search_name"
            ;;
        6) 
            echo "Exiting..."
            exit 0
            ;;
        *) 
            echo "Invalid choice! Please enter a number between 1 and 6."
            ;;
    esac
done
