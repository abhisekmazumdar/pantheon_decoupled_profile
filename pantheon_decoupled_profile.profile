<?php

/**
 * @file
 * Enables modules and site configuration for a custom site installation.
 */

use Drupal\field\Entity\FieldStorageConfig;
use Drupal\user\Entity\Role;
use Drupal\user\RoleInterface;

/**
 * Implements hook_install_tasks().
 */
function pantheon_decoupled_profile_install_tasks(&$install_state) {
  $tasks['pantheon_decoupled_install_demo_content'] = [
    'display_name' => t('Install demo content'),
    'display' => TRUE,
  ];
  $tasks['pantheon_decoupled_enable_media_field'] = [
    'display_name' => t('Enable the media image field for article content type'),
    'display' => TRUE,
  ];
  $tasks['pantheon_decoupled_set_media_permissions'] = [
    'display_name' => t('Set correct media viewing permission for anonymous & authenticated users'),
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
  \Drupal::service('module_installer')->install(['pantheon_decoupled_example']);
}

/**
 * Enable media image field for Article content type.
 *
 * @param array $install_state
 *   An array of information about the current installation state. The chosen
 *   langcode will be added here, if it was not already selected previously, as
 *   will a list of all available languages.
 *
 * @throws \Drupal\Core\Entity\EntityStorageException
 */
function pantheon_decoupled_enable_media_field(array &$install_state) {
  /** @var \Drupal\Core\Entity\EntityDisplayRepositoryInterface $entityDisplayRepository */
  $entityDisplayRepository = \Drupal::service('entity_display.repository');
  $entityDisplayRepository->getFormDisplay('node', 'article', 'default')
    ->setComponent('field_media_image', [
      'type' => 'media_library_widget',
      'weight' => 4,
    ])
    ->save();
  $entityDisplayRepository->getViewDisplay('node', 'article', 'default')
    ->setComponent('field_media_image', [
      'type' =>  'entity_reference_entity_view',
      'label' => 'hidden',
      'weight' => -1,
    ])
    ->save();
  $entityDisplayRepository->getViewDisplay('node', 'article', 'teaser')
    ->setComponent('field_media_image', [
      'type' =>  'entity_reference_entity_view',
      'label' => 'hidden',
      'weight' => -1,
    ])
    ->save();
  FieldStorageConfig::loadByName('node', 'field_image')->delete();
}

/**
 * Set correct media viewing permission for anonymous & authenticated users.
 *
 * @param array $install_state
 *   An array of information about the current installation state. The chosen
 *   langcode will be added here, if it was not already selected previously, as
 *   will a list of all available languages.
 *
 * @return void
 */
function pantheon_decoupled_set_media_permissions(array &$install_state) {
  Role::load(RoleInterface::ANONYMOUS_ID)
    ->grantPermission('view media')
    ->save();
  Role::load(RoleInterface::AUTHENTICATED_ID)
    ->grantPermission('view media')
    ->save();
}
