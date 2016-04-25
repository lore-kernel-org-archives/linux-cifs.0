From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 25/41] Documentation: filesystems: fix spelling mistakes
Date: Sun, 24 Apr 2016 21:09:41 -0500
Message-ID: <CAH2r5mtZJ5=jiGKweZWuTrZavAv=YbJjbQb6DV-_BvtU9z64KA@mail.gmail.com>
References: <1461543878-3639-1-git-send-email-eric@engestrom.ch> <1461543878-3639-26-git-send-email-eric@engestrom.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>,
	Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>,
	Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
	Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>,
	Chen Hanxiao <chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>,
	Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	"Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	Thomas de Beauchene <thomas.chauvot-de-beauchene-r+tYf39mQ+Fulxpn9UvDqw@public.gmane.org>,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpk@public.gmane.org
To: Eric Engestrom <eric-op+oiCINJLTt9jDmeYuA0g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461543878-3639-26-git-send-email-eric-op+oiCINJLTt9jDmeYuA0g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

On Sun, Apr 24, 2016 at 7:24 PM, Eric Engestrom <eric-op+oiCINJLTt9jDmeYuA0g@public.gmane.org> wrote:
> Signed-off-by: Eric Engestrom <eric-op+oiCINJLTt9jDmeYuA0g@public.gmane.org>
> ---
>  Documentation/filesystems/autofs4.txt  | 6 +++---
>  Documentation/filesystems/cifs/CHANGES | 2 +-
>  Documentation/filesystems/proc.txt     | 4 ++--
>  Documentation/filesystems/vfs.txt      | 2 +-
>  4 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/filesystems/autofs4.txt b/Documentation/filesystems/autofs4.txt
> index 39d02e1..25fe9db 100644
> --- a/Documentation/filesystems/autofs4.txt
> +++ b/Documentation/filesystems/autofs4.txt
> @@ -225,7 +225,7 @@ unmount any filesystems mounted on the autofs filesystem or remove any
>  symbolic links or empty directories any time it likes.  If the unmount
>  or removal is successful the filesystem will be returned to the state
>  it was before the mount or creation, so that any access of the name
> -will trigger normal auto-mount processing.  In particlar, `rmdir` and
> +will trigger normal auto-mount processing.  In particular, `rmdir` and
>  `unlink` do not leave negative entries in the dcache as a normal
>  filesystem would, so an attempt to access a recently-removed object is
>  passed to autofs for handling.
> @@ -242,7 +242,7 @@ time stamp on each directory or symlink.  For symlinks it genuinely
>  does record the last time the symlink was "used" or followed to find
>  out where it points to.  For directories the field is a slight
>  misnomer.  It actually records the last time that autofs checked if
> -the directory or one of its descendents was busy and found that it
> +the directory or one of its descendants was busy and found that it
>  was.  This is just as useful and doesn't require updating the field so
>  often.
>
> @@ -255,7 +255,7 @@ up.
>
>  There is an option with indirect mounts to consider each of the leaves
>  that has been mounted on instead of considering the top-level names.
> -This is intended for compatability with version 4 of autofs and should
> +This is intended for compatibility with version 4 of autofs and should
>  be considered as deprecated.
>
>  When autofs considers a directory it checks the `last_used` time and
> diff --git a/Documentation/filesystems/cifs/CHANGES b/Documentation/filesystems/cifs/CHANGES
> index bc0025c..fe8f1ed 100644
> --- a/Documentation/filesystems/cifs/CHANGES
> +++ b/Documentation/filesystems/cifs/CHANGES
> @@ -455,7 +455,7 @@ Fix internationalization problem in cifs readdir with filenames that map to
>  longer UTF-8 strings than the string on the wire was in Unicode.  Add workaround
>  for readdir to netapp servers. Fix search rewind (seek into readdir to return
>  non-consecutive entries).  Do not do readdir when server negotiates
> -buffer size to small to fit filename. Add support for reading POSIX ACLs from
> +buffer size too small to fit filename. Add support for reading POSIX ACLs from
>  the server (add also acl and noacl mount options).
>
>  Version 1.24
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 7f5607a..03b6019 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -462,7 +462,7 @@ accessed.
>  "Anonymous" shows the amount of memory that does not belong to any file.  Even
>  a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
>  and a page is modified, the file page is replaced by a private anonymous copy.
> -"AnonHugePages" shows the ammount of memory backed by transparent hugepage.
> +"AnonHugePages" shows the amount of memory backed by transparent hugepage.
>  "Shared_Hugetlb" and "Private_Hugetlb" show the ammounts of memory backed by
>  hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
>  reasons. And these are not included in {Shared,Private}_{Clean,Dirty} field.
> @@ -1899,7 +1899,7 @@ hidepid=1 means users may not access any /proc/<pid>/ directories but their
>  own.  Sensitive files like cmdline, sched*, status are now protected against
>  other users.  This makes it impossible to learn whether any user runs
>  specific program (given the program doesn't reveal itself by its behaviour).
> -As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
> +As an additional bonus, as /proc/<pid>/cmdline is inaccessible for other users,
>  poorly written programs passing sensitive information via program arguments are
>  now protected against local eavesdroppers.
>
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index 4164bd6..ec67866 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -1014,7 +1014,7 @@ struct dentry_operations {
>         Useful for some pseudo filesystems (sockfs, pipefs, ...) to delay
>         pathname generation. (Instead of doing it when dentry is created,
>         it's done only when the path is needed.). Real filesystems probably
> -       dont want to use it, because their dentries are present in global
> +       don't want to use it, because their dentries are present in global
>         dcache hash, so their hash should be an invariant. As no lock is
>         held, d_dname() should not try to modify the dentry itself, unless
>         appropriate SMP safety is used. CAUTION : d_path() logic is quite
> --
> 2.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
