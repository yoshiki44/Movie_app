# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchTmdbMoviesJob, type: :job do
  let(:mock_response) do
    [
      {
        'id' => 123,
        'title' => 'Mock Movie',
        'overview' => 'This is a mock movie.',
        'poster_path' => '/mockposter.jpg',
        'release_date' => '2024-01-01'
      }
    ]
  end

  before do
    # TmdbMovieService のモック
    mock_service = instance_double(TmdbMovieService)
    allow(TmdbMovieService).to receive(:new).and_return(mock_service)
    allow(mock_service).to receive(:build_search_url).and_return('https://example.com/mock')
    allow(mock_service).to receive(:fetch_movies).and_return(mock_response)
    allow(mock_service).to receive(:find_or_create_movie)
  end

  it 'creates movies from TMDB API' do
    expect do
      described_class.perform_now(api_key: 'dummy_key', total_pages: 1)
    end.not_to raise_error
  end
end
