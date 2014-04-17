<?php

namespace Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 *
 * @license see /license.txt
 * @author autogenerated
 */
class ForumCategory extends \CourseEntity
{
    /**
     * @return \Entity\Repository\ForumCategoryRepository
     */
     public static function repository(){
        return \Entity\Repository\ForumCategoryRepository::instance();
    }

    /**
     * @return \Entity\ForumCategory
     */
     public static function create(){
        return new self();
    }

    /**
     * @var integer $c_id
     */
    protected $c_id;

    /**
     * @var integer $cat_id
     */
    protected $cat_id;

    /**
     * @var string $cat_title
     */
    protected $cat_title;

    /**
     * @var text $cat_comment
     */
    protected $cat_comment;

    /**
     * @var integer $cat_order
     */
    protected $cat_order;

    /**
     * @var integer $locked
     */
    protected $locked;

    /**
     * @var integer $session_id
     */
    protected $session_id;


    /**
     * Set c_id
     *
     * @param integer $value
     * @return ForumCategory
     */
    public function set_c_id($value)
    {
        $this->c_id = $value;
        return $this;
    }

    /**
     * Get c_id
     *
     * @return integer 
     */
    public function get_c_id()
    {
        return $this->c_id;
    }

    /**
     * Set cat_id
     *
     * @param integer $value
     * @return ForumCategory
     */
    public function set_cat_id($value)
    {
        $this->cat_id = $value;
        return $this;
    }

    /**
     * Get cat_id
     *
     * @return integer 
     */
    public function get_cat_id()
    {
        return $this->cat_id;
    }

    /**
     * Set cat_title
     *
     * @param string $value
     * @return ForumCategory
     */
    public function set_cat_title($value)
    {
        $this->cat_title = $value;
        return $this;
    }

    /**
     * Get cat_title
     *
     * @return string 
     */
    public function get_cat_title()
    {
        return $this->cat_title;
    }

    /**
     * Set cat_comment
     *
     * @param text $value
     * @return ForumCategory
     */
    public function set_cat_comment($value)
    {
        $this->cat_comment = $value;
        return $this;
    }

    /**
     * Get cat_comment
     *
     * @return text 
     */
    public function get_cat_comment()
    {
        return $this->cat_comment;
    }

    /**
     * Set cat_order
     *
     * @param integer $value
     * @return ForumCategory
     */
    public function set_cat_order($value)
    {
        $this->cat_order = $value;
        return $this;
    }

    /**
     * Get cat_order
     *
     * @return integer 
     */
    public function get_cat_order()
    {
        return $this->cat_order;
    }

    /**
     * Set locked
     *
     * @param integer $value
     * @return ForumCategory
     */
    public function set_locked($value)
    {
        $this->locked = $value;
        return $this;
    }

    /**
     * Get locked
     *
     * @return integer 
     */
    public function get_locked()
    {
        return $this->locked;
    }

    /**
     * Set session_id
     *
     * @param integer $value
     * @return ForumCategory
     */
    public function set_session_id($value)
    {
        $this->session_id = $value;
        return $this;
    }

    /**
     * Get session_id
     *
     * @return integer 
     */
    public function get_session_id()
    {
        return $this->session_id;
    }
}