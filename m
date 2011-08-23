From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/5] cifs-utils: cifsacl utilities: Create file
 cifsacl.h
Date: Tue, 23 Aug 2011 08:46:53 -0400
Message-ID: <20110823084653.6376859c@corrin.poochiereds.net>
References: <1313810842-2268-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313810842-2268-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 19 Aug 2011 22:27:22 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add defines and structures related to security descriptor, ACL,
> ACE, various fields within an ACE, and SID.
> Also define various file permissions and acess types.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  cifsacl.h |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 127 insertions(+), 0 deletions(-)
>  create mode 100644 cifsacl.h
> 
> diff --git a/cifsacl.h b/cifsacl.h
> new file mode 100644
> index 0000000..e9b7d50
> --- /dev/null
> +++ b/cifsacl.h
> @@ -0,0 +1,127 @@
> +#ifdef HAVE_CONFIG_H
> +#include "config.h"
> +#endif /* HAVE_CONFIG_H */
> +
> +#include <string.h>
> +#include <getopt.h>
> +#include <syslog.h>
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <limits.h>
> +#include <wbclient.h>
> +#include <ctype.h>
> +#include <sys/xattr.h>
> +

I think it would be more appropriate to not include the above headers
from this include file, and instead have the *.c files include them
individually.

Also, this entire file needs to be wrapped in the standard construct to
protect against multiple inclusions.

> +#define BUFSIZE 1024
> +#define ATTRNAME "system.cifs_acl"
> +
> +#define MAX_NUM_AUTHS 6
> +
> +/* File specific rights */
> +#define READ_DATA	0x00000001 /* R */
> +#define WRITE_DATA	0x00000002 /* W */
> +#define APPEND_DATA	0x00000004 /* A */
> +#define READ_EA		0x00000008 /* REA */
> +#define WRITE_EA	0x00000010 /* WEA */
> +#define EXEC		0x00000020 /* E */
> +#define DELDHLD		0x00000040 /* DC */
> +#define READ_ATTR	0x00000080 /* RA */
> +#define WRITE_ATTR	0x00000100 /* WA */
> +
> +/* Standard rights */
> +#define DELETE		0x00010000 /* D */
> +#define READ_CONTROL	0x00020000 /* RC */
> +#define WRITE_DAC	0x00040000 /* P */
> +#define WRITE_OWNER	0x00080000 /* O */
> +#define SYNC		0x00100000 /* S */
> +
> +/* Generic rights */
> +#define SYSSEC		0x01000000
> +#define MAX		0x02000000
> +#define ALL		0x10000000
> +#define EXECUTE		0x20000000 /* GE */
> +#define WRITE		0x40000000 /* GW */
> +#define READ		0x80000000 /* GR */
> +
> +/* D | RC | P | O | S | R | W | A | E | DC | REA | WEA | RA | WA  */
> +#define FULL_CONTROL	0x001f01ff
> +
> +/* RC | S | R | E | REA | RA */
> +#define EREAD		0x001200a9
> +
> +/* RC | S | R | E | REA | GR | GE */
> +#define OREAD		0xa01200a1
> +
> +/* RC | S | R | REA | RA */
> +#define BREAD		0x00120089
> +
> +/* W | A | WA | WEA| */
> +#define EWRITE		0x00000116
> +
> +/* D | RC | S | R | W | A | E |REA | WEA | RA | WA */
> +#define CHANGE		0x001301bf
> +
> +/* GR | RC | REA | RA | REA | R */
> +#define ALL_READ_BITS	0x80020089
> +
> +/* WA | WEA | A | W */
> +#define ALL_WRITE_BITS	0x40000116
> +
> +#define OBJECT_INHERIT_FLAG 0x01	/* OI */
> +#define CONTAINER_INHERIT_FLAG 0x02	/* CI */
> +#define NO_PROPAGATE_INHERIT_FLAG 0x04	/* NP */
> +#define INHERIT_ONLY_FLAG 0x08		/* IO */
> +#define INHERITED_ACE_FLAG 0x10		/* I */
> +#define VFLAGS 0x1f
> +
> +#define ACCESS_ALLOWED	0		/* ALLOWED */
> +#define ACCESS_DENIED	1		/* DENIED */
> +#define ACCESS_ALLOWED_OBJECT	5	/* OBJECT_ALLOWED */
> +#define ACCESS_DENIED_OBJECT	6	/* OBJECT_DENIED */
> +
> +#define COMPSID 0x1
> +#define COMPTYPE 0x2
> +#define COMPFLAG 0x4
> +#define COMPMASK 0x8
> +#define COMPALL 0xf /* COMPSID | COMPTYPE | COMPFLAG | COMPMASK */
> +
> +enum ace_action {
> +	acedelete = 0,
> +	acemodify,
> +	aceadd,
> +	aceset
> +};
> +
> +struct cifs_ntsd {
> +	uint16_t revision; /* revision level */
> +	uint16_t type;
> +	uint32_t osidoffset;
> +	uint32_t gsidoffset;
> +	uint32_t sacloffset;
> +	uint32_t dacloffset;
> +};
> +
> +struct cifs_sid {
> +	uint8_t revision; /* revision level */
> +	uint8_t num_subauth;
> +	uint8_t authority[6];
> +	uint32_t sub_auth[5]; /* sub_auth[num_subauth] */
> +};
> +
> +struct cifs_ctrl_acl {
> +	uint16_t revision; /* revision level */
> +	uint16_t size;
> +	uint32_t num_aces;
> +};
> +
> +struct cifs_ace {
> +	uint8_t type;
> +	uint8_t flags;
> +	uint16_t size;
> +	uint32_t access_req;
> +	struct cifs_sid sid; /* ie UUID of user or group who gets these perms */
> +};


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
