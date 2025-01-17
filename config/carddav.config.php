<?php
/***********************************************
* File      :   config.php
* Project   :   Z-Push
* Descr     :   CardDAV backend configuration file
*
* Created   :   16.03.2013
*
* Copyright 2013 - 2016 Francisco Miguel Biete
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License, version 3,
* as published by the Free Software Foundation.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
* Consult LICENSE file for details
************************************************/

// ************************
//  BackendCardDAV settings
// ************************

// Server protocol: http or https
define('CARDDAV_PROTOCOL', ($_ENV['CARDDAV_PROTOCOL'] ? $_ENV['CARDDAV_PROTOCOL'] : null));

// Server name
define('CARDDAV_SERVER', ($_ENV['CARDDAV_SERVER'] ? $_ENV['CARDDAV_SERVER'] : null));

// Server port
define('CARDDAV_PORT', ($_ENV['CARDDAV_PORT'] ? $_ENV['CARDDAV_PORT'] : null));

// Server path to the addressbook, or the principal with the addressbooks
//  If your user has more than 1 addressbook point it to the principal.
//  Example: user test@domain.com will have 2 addressbooks
//      http://localhost/caldav.php/test@domain.com/addresses/personal
//      http://localhost/caldav.php/test@domain.com/addresses/work
//      You set the CARDDAV_PATH to '/caldav.php/%u/addresses/' and personal and work will be autodiscovered
// %l: replaced with the local part of the username
// %u: replaced with the username
// %d: replaced with the domain
//   Add the trailing /
define('CARDDAV_PATH', ($_ENV['CARDDAV_PATH'] ? $_ENV['CARDDAV_PATH'] : null));


// Server path to the default addressbook
//  Mobile device will create new contacts here. It must be under CARDDAV_PATH
// %l: replaced with the local part of the username
// %u: replaced with the username
// %d: replaced with the domain
//   Add the trailing /
define('CARDDAV_DEFAULT_PATH', ($_ENV['CARDDAV_DEFAULT_PATH'] ? $_ENV['CARDDAV_DEFAULT_PATH'] : null));

// Server path to the GAL addressbook. This addressbook is readonly and searchable by the user, but it will NOT be synced.
// If you don't want GAL, comment it
// %l: replaced with the local part of the username
// %u: replaced with the username
// %d: replaced with the domain
//  Add the trailing /
define('CARDDAV_GAL_PATH', ($_ENV['CARDDAV_GAL_PATH'] ? $_ENV['CARDDAV_GAL_PATH'] : null));

// Minimal length for the search pattern to do the real search.
define('CARDDAV_GAL_MIN_LENGTH', ($_ENV['CARDDAV_GAL_MIN_LENGTH'] ? (int)$_ENV['CARDDAV_GAL_MIN_LENGTH'] : null));

// Addressbook display name, the name showed in the mobile device
// %l: replaced with the local part of the username
// %u: replaced with the username
// %d: replaced with the domain
define('CARDDAV_CONTACTS_FOLDER_NAME', ($_ENV['CARDDAV_CONTACTS_FOLDER_NAME'] ? $_ENV['CARDDAV_CONTACTS_FOLDER_NAME'] : null));


// If the CardDAV server supports the sync-collection operation
// DAViCal and SabreDav support it, but Owncloud, SOGo don't
// SabreDav version must be at least 1.9.0, otherwise set this to false
// Setting this to false will work with most servers, but it will be slower: 1 petition for the href of vcards, and 1 petition for each vcard
define('CARDDAV_SUPPORTS_SYNC', false);


// If the CardDAV server supports the FN attribute for searches
// DAViCal supports it, but SabreDav, Owncloud and SOGo don't
// Setting this to true will search by FN. If false will search by sn, givenName and email
// It's safe to leave it as false
define('CARDDAV_SUPPORTS_FN_SEARCH', false);


// If your carddav server needs to use file extension to recover a vcard.
//    Davical needs it
//    SOGo official demo online needs it, but some SOGo installation don't need it, so test it
define('CARDDAV_URL_VCARD_EXTENSION', '.vcf');
