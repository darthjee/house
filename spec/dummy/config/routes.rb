# frozen_string_literal: true

Rails.application.routes.draw do
  resources :document_report, only: [] do
    collection do
      get :error_status
      get :range_status
      get :multiple_status
    end
  end

  resources :example_report, only: [] do
    get :status, on: :collection
  end
end
