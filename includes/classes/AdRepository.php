<?php
// includes/classes/AdRepository.php

class AdRepository extends BaseRepository
{
    public function getAll()
    {
        return $this->fetchAll("SELECT * FROM advertisements ORDER BY created_at DESC");
    }

    public function create(array $data)
    {
        $params = [
            'client_name' => $data['client_name'] ?? null,
            'title'       => $data['title'] ?? null,
            'description' => $data['description'] ?? null,
            'media_path'  => $data['media_path'] ?? null,
            'image_url'   => $data['image_url'] ?? null,
            'link_url'    => $data['link_url'] ?? null,
            'status'      => $data['status'] ?? 'Active',
        ];
        $sql = "INSERT INTO advertisements (client_name, title, description, media_path, image_url, link_url, status, created_at) 
                VALUES (:client_name, :title, :description, :media_path, :image_url, :link_url, :status, NOW())";
        $this->execute($sql, $params);
        return $this->pdo->lastInsertId();
    }

    public function update($id, array $data)
    {
        $fields = [];
        foreach ($data as $key => $value) {
            $fields[] = "$key = :$key";
        }
        $sql = "UPDATE advertisements SET " . implode(', ', $fields) . " WHERE id = :id";
        $data['id'] = $id;
        return $this->execute($sql, $data);
    }

    public function delete($id)
    {
        return $this->execute("DELETE FROM advertisements WHERE id = ?", [$id]);
    }
}
