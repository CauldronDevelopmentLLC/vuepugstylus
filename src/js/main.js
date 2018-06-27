/******************************************************************************\

                    Copyright 2018. Cauldron Development LLC
                              All Rights Reserved.

                  For information regarding this software email:
                                 Joseph Coffland
                          joseph@cauldrondevelopment.com

        This software is free software: you can redistribute it and/or
        modify it under the terms of the GNU Lesser General Public License
        as published by the Free Software Foundation, either version 2.1 of
        the License, or (at your option) any later version.

        This software is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
        Lesser General Public License for more details.

        You should have received a copy of the GNU Lesser General Public
        License along with the C! library.  If not, see
        <http://www.gnu.org/licenses/>.

\******************************************************************************/

'use strict'


var __app = {
  el: 'body',

  components: {
    'hello-component': require('./hello')
    // Add hierarchical components here
  }
}


$(function () {
  // Detect incompatible browsers
  if (!Object.defineProperty) {
    $('#incompatible-browser')
      .show()
      .find('.page-content')
      .append(
        $('<button>')
          .addClass('success')
          .text('Update')
          .click(function () {window.location = 'http://whatbrowser.org/'})
      )

    return
  }

  // Vue debugging
  Vue.config.debug = true;

  // Add vue.js filters and global components here
  //
  // Vue.filter('filter_name', function (value) {
  //   // Modify value
  //   return value;
  // });
  //
  //
  //  Vue.component('component-name', require('./component-name'));

  // Vue app
  new Vue(__app);
})
