<?php

/**
 * @file
 * Enables modules and site configuration for a custom site installation.
 */

use Drupal\field\Entity\FieldConfig;

/**
 * Implements hook_install_tasks().
 */
function pantheon_decoupled_profile_install_tasks(&$install_state) {
  $tasks['pantheon_decoupled_install_demo_content'] = [
    'display_name' => t('Install demo content'),
    'display' => TRUE,
  ];
  return $tasks;
}

/**
 * Install the pantheon_decoupled_example module.
 *
 * @param array $install_state
 *   An array of information about the current installation state. The chosen
 *   langcode will be added here, if it was not already selected previously, as
 *   will a list of all available languages.
 */
function pantheon_decoupled_install_demo_content(array &$install_state) {

  // Delete the default image field from article content type.
  FieldConfig::loadByName('node', 'article', 'field_image')->delete();

  // @TODO: This manual cache clearing should not be necessary,
  // if https://www.drupal.org/project/drupal/issues/3076544 is fixed.
  if (\Drupal::database()->schema()->tableExists('cache_discovery')) {
    \Drupal::database()->truncate('cache_discovery')->execute();
  }

  \Drupal::service('module_installer')->install(['pantheon_decoupled_example']);
}
