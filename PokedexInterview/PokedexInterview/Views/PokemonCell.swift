//
//  PokemonCell.swift
//  PokedexInterview
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import UIKit

class PokemonCell: UITableViewCell {
    
    let pokemonImageView = UIImageView()
    let nameLabel = UILabel()
    let type1Label = UILabel()
    let type2Label = UILabel()
    let descriptionLabel = UILabel()
    
    // Initialize properties
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup views
    private func setupViews() {
        // Configure ImageView
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pokemonImageView)
        
        // Configure Name Label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        // Configure Type Labels
        configureTypeLabel(type1Label)
        configureTypeLabel(type2Label)
        
        // Configure Description Label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
    }
    
    private func configureTypeLabel(_ label: UILabel) {
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .secondarySystemBackground
        label.textColor = .gray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
    }
    
    // Setup constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 90),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 90),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            type1Label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            type1Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            type1Label.heightAnchor.constraint(equalToConstant: 20),
            type1Label.widthAnchor.constraint(equalToConstant: 60),
            
            type2Label.leadingAnchor.constraint(equalTo: type1Label.trailingAnchor, constant: 8),
            type2Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            type2Label.heightAnchor.constraint(equalToConstant: 20),
            type2Label.widthAnchor.constraint(equalToConstant: 60),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: type1Label.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configureCell(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        type1Label.text = pokemon.type1.description
        type2Label.text = pokemon.type2?.description
        type2Label.isHidden = pokemon.type2 == nil
        descriptionLabel.text = "Weight: " + (pokemon.weight?.description ?? "0.0") + " kg"
        ImageCache.default.loadImage(from: pokemon.imageName ?? "") { [weak self] image in
            self?.pokemonImageView.image = image
        }
    }
}
