namespace :gallery do
  desc "Seed gallery groups/photos from app/assets/images/gallery (skips groups that already have photos)"
  task seed: :environment do
    groups = [
      { slug: "nikah", title: "Никах", description: "Бракосочетания по Сунне в главном зале мечети", dir: "nikah", prefix: "nikah", cover: 7 },
      { slug: "isem-kushu", title: "Исем кушу", description: "Имянаречение новорождённых по традиции", dir: "isem-kushu", prefix: "isem-kushu", cover: 8 },
      { slug: "ramadan-2026", title: "Рамадан 2026", description: "Совместные ифтары, таравих-намазы и встречи общины", dir: "ramadan-2026", prefix: "ramadan", cover: 10 }
    ]

    groups.each_with_index do |attrs, group_position|
      group = GalleryGroup.find_or_initialize_by(slug: attrs[:slug])
      group.update!(title: attrs[:title], description: attrs[:description], position: group_position)

      if group.gallery_photos.any?
        puts "#{group.title}: уже есть #{group.gallery_photos.count} фото, пропускаю"
        next
      end

      dir = Rails.root.join("app/assets/images/gallery/#{attrs[:dir]}")
      files = Dir.glob(dir.join("#{attrs[:prefix]}-*.jpg")).sort_by { |f| f[/-(\d+)\.jpg\z/, 1].to_i }
      cover_path = dir.join("#{attrs[:prefix]}-#{attrs[:cover]}.jpg").to_s
      ordered_files = [ cover_path, *(files - [ cover_path ]) ].select { |f| File.exist?(f) }

      ordered_files.each_with_index do |path, i|
        photo = group.gallery_photos.create!(position: i)
        photo.image.attach(
          io: File.open(path),
          filename: File.basename(path),
          content_type: "image/jpeg"
        )
      end

      puts "#{group.title}: загружено #{group.gallery_photos.count} фото"
    end
  end
end
