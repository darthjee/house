# frozen_string_literal: true

Rails.application.routes.draw do
  resources :error_report, only: [] do
    get :status, on: :collection
  end
end
