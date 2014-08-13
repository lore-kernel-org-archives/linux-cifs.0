From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][CIFS] Add missing definitions for CIFS File System Attributes
Date: Tue, 12 Aug 2014 23:42:16 -0500
Message-ID: <CADT32eKZA4j9sQXpppTOK1iWrfBVdoWXkPe1MJGPgzb4Lv8EwQ@mail.gmail.com>
References: <CAH2r5mu6y8Kq1KDZ+WTL1-ra66o03EPj_rNJGV8YqGvOFFYfaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu6y8Kq1KDZ+WTL1-ra66o03EPj_rNJGV8YqGvOFFYfaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Tue, Aug 12, 2014 at 9:10 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Add missing definitions for CIFS File System Attributes
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifspdu.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 33df36e..0337445 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -2253,6 +2253,29 @@ typedef struct {
>  /* minimum includes first three fields, and empty FS Name */
>  #define MIN_FS_ATTR_INFO_SIZE 12
>
> +
> +/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
> +#define FILE_SUPPORT_INTEGRITY_STREAMS    0x04000000
> +#define FILE_SUPPORTS_USN_JOURNAL    0x02000000
> +#define FILE_SUPPORTS_OPEN_BY_FILE_ID    0x01000000
> +#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
> +#define FILE_SUPPORTS_HARD_LINKS    0x00400000
> +#define FILE_SUPPORTS_TRANSACTIONS    0x00200000
> +#define FILE_SEQUENTIAL_WRITE_ONCE    0x00100000
> +#define FILE_READ_ONLY_VOLUME        0x00080000
> +#define FILE_NAMED_STREAMS        0x00040000
> +#define FILE_SUPPORTS_ENCRYPTION    0x00020000
> +#define FILE_SUPPORTS_OBJECT_IDS    0x00010000
> +#define FILE_VOLUME_IS_COMPRESSED    0x00008000
> +#define FILE_SUPPORTS_REMOTE_STORAGE    0x00000100
> +#define FILE_SUPPORTS_REPARSE_POINTS    0x00000080
> +#define FILE_SUPPORTS_SPARSE_FILES    0x00000040
> +#define FILE_VOLUME_QUOTAS        0x00000020
> +#define FILE_FILE_COMPRESSION         0x00000010
> +#define FILE_PERSISTENT_ACLS        0x00000008
> +#define FILE_UNICODE_ON_DISK        0x00000004
> +#define FILE_CASE_PRESERVED_NAMES    0x00000002
> +#define FILE_CASE_SENSITIVE_SEARCH    0x00000001
>  typedef struct {
>      __le32 Attributes;
>      __le32 MaxPathNameComponentLength;
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
