From: Jeff Layton <jeff.layton@primarydata.com>
Subject: Re: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write
 response
Date: Thu, 14 Aug 2014 15:30:15 -0400
Message-ID: <20140814153015.030657f7@tlielax.poochiereds.net>
References: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 12 Aug 2014 09:19:42 -0500
Steve French <smfrench@gmail.com> wrote:

> Writes fail to Mac servers with SMB2.1 mounts (works with cifs though) due
> to them sending an incorrect RFC1001 length. Workaround this problem.
> MacOS server sends a write response with 3 bytes of pad beyond the end
> of the SMB itself.  The RFC1001 length is 3 bytes more than
> the sum of the SMB2.1 header length + the write reponse.
> 
> Since we have seen a few other examples where servers have
> padded responses strangely (oplock break and create),
> allow servers to send a padded SMB2/SMB3 response to allow
> for rounding (up to 15 bytes).
> 
> Signed-off-by: Steve French <smfrench@gmail.com>
> ---
>  fs/cifs/smb2misc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index f2e6ac2..da05beb 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -181,6 +181,12 @@ smb2_check_message(char *buf, unsigned int length)
>          /* server can return one byte more */
>          if (clc_len == 4 + len + 1)
>              return 0;

Not directly related to this patch, but...

What's the story behind the check above? Allowing the server to overrun
the rfc1001 length by one byte seems dangerous...

> +
> +        /* MacOS server pads after SMB2.1 write response with 3 bytes */
> +        /* of junk. Allow server to pad up to 15 bytes of junk at end */
> +        if ((clc_len < 4 + len) && (clc_len > 4 + len - 16))
> +            return 0;
> +

I don't understand the rationale for the arbitrary 15 byte limit. At
this point, you've already received the data. If there's extra junk at
the end, do you really care? I'd just ensure that clc_len fits within
the rfc1001 len and leave it at that.

>          return 1;
>      }
>      return 0;
> 


-- 
Jeff Layton <jlayton@primarydata.com>
