#lang racket

(define is-windows
  (eq? (system-type 'os)
       'windows))

(define is-mac
  (eq? (system-type 'os)
       'macosx))

(define is-unix
  (eq? (system-type 'os)
       'unix))

(define dir-sep
  (cond (is-windows "\\")
        (else "/")))

(define (path-append path str)
  (string->path (string-append (path->string path) str)))

(define ff-profiles-dir
  (path-append (find-system-path 'home-dir)
               (cond (is-windows "AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\")
                     (is-unix ".mozilla/Firefox/Profiles/")
                     (is-mac "Library/Mozilla/Firefox/Profiles/"))))

(define ff-profiles-dirs
  (map (lambda (sub-dir)
         (build-path ff-profiles-dir sub-dir))
       (directory-list ff-profiles-dir)))

(define (ff-copy-cookie profile)
  (copy-file (path-append (build-path ff-profiles-dir profile)
                          (string-append dir-sep "cookies.sqlite"))
             (path-append (find-system-path 'orig-dir)
                          (string-append "ff."
                                         (path->string profile)
                                         ".cookies.sqlite"))))

(define (ff-copy-cookies)
  (map ff-copy-cookie
       (directory-list ff-profiles-dir)))

(define gc-cookies-dir
  (path-append (find-system-path 'home-dir)
               (cond (is-windows "AppData\\Local\\Google\\Chrome\\User Data\\Default\\")
                     (is-unix ".config/google-chrome/Default/")
                     (is-mac "Library/Application Support/Google/Chrome/Default/"))))

(define (gc-copy-cookies)
  (copy-file (path-append gc-cookies-dir "Cookies")
             (path-append (find-system-path 'orig-dir)
                          "gc.Cookies.sqlite")))
