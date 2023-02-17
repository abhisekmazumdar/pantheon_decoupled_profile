<?php

/**
 * @file
 * Enables modules and site configuration for a custom site installation.
 */

use Drupal\field\Entity\FieldConfig;
use Drupal\contact\Entity\ContactForm;
use Drupal\Core\Form\FormStateInterface;

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function pantheon_decoupled_profile_form_install_configure_form_alter(&$form, FormStateInterface $form_state) {
  $form['#submit'][] = 'pantheon_decoupled_profile_form_install_configure_submit';
}

/**
 * Submission handler to sync the contact.form.feedback recipient.
 */
function pantheon_decoupled_profile_form_install_configure_submit($form, FormStateInterface $form_state) {
  $site_mail = $form_state->getValue('site_mail');
  ContactForm::load('feedback')->setRecipients([$site_mail])->trustData()->save();
}

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
