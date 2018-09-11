From: Jon Kuhn <jkuhn@barracuda.com>
Subject: Re: [PATCH] fs/cifs: don't translate SFM_SLASH (U+F026) to backslash
Date: Tue, 11 Sep 2018 12:41:11 +0000
Message-ID: <1536669671991.92366@barracuda.com>
References: <20180709143314.4378-1-jkuhn@barracuda.com>,<CAH2r5muQXJFzut4upVAk-nTFv3qGGOaG+QKLkGgqGA1HitUMGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muQXJFzut4upVAk-nTFv3qGGOaG+QKLkGgqGA1HitUMGg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Do you have specific scenarios you'd like to see tested?

I created files containing the following characters on a 
Windows 2012 R2 file server from an OS X 10.13.4 client:

    back slash (translates to U+F026)
    forward slash (translates to U+F022)
    greater than (translates to U+F024)
    less than (translates to U+F023)
    pipe (translates to U+F027)
    question mark (translates to U+F025)
    asterisk (translates to U+F021)

I then mounted the file server from an Ubuntu 18.04 LTS (kernel 4.15.20)
machine (normally without the -o mapchars option).

Before my change, all files except the one containing the backslash could
be opened using the name they are given when you list the directory.  The
backslash was represented as a literal backslash in directory listings, but
could not be opened using that name.

After my change, all files can be opened using the name they are given
when you list the directory.  However, the backslash is represented as
U+F026 in the directory listing since I removed the translation.

I think this change makes the SFM_SLASH behavior consistent
with the UNI_SLASH behavior, since there is a comment in
convert_sfu_char() that states:

	/*
	 * BB: Cannot handle remapping UNI_SLASH until all the calls to
	 *     build_path_from_dentry are modified, as they use slash as
	 *     separator.
	 */

________________________________________
From: Steve French <smfrench@gmail.com>
Sent: Sunday, August 26, 2018 9:40 PM
To: Jon Kuhn
Cc: Steve French; CIFS; samba-technical; LKML
Subject: Re: [PATCH] fs/cifs: don't translate SFM_SLASH (U+F026) to backslash

Tentatively merged into cifs-2.6.git for-next but would like a little
more experimentation with it if possible (or description of what
scenarios/servers have been tried)
On Mon, Jul 9, 2018 at 9:53 AM Jon Kuhn <jkuhn@barracuda.com> wrote:
>
> When a Mac client saves an item containing a backslash to a file server
> the backslash is represented in the CIFS/SMB protocol as as U+F026.
> Before this change, listing a directory containing an item with a
> backslash in its name will return that item with the backslash
> represented with a true backslash character (U+005C) because
> convert_sfm_character mapped U+F026 to U+005C when interpretting the
> CIFS/SMB protocol response.  However, attempting to open or stat the
> path using a true backslash will result in an error because
> convert_to_sfm_char does not map U+005C back to U+F026 causing the
> CIFS/SMB request to be made with the backslash represented as U+005C.
>
> This change simply prevents the U+F026 to U+005C conversion from
> happenning.  This is analogous to how the code does not do any
> translation of UNI_SLASH (U+F000).
>
> Signed-off-by: Jon Kuhn <jkuhn@barracuda.com>
> ---
>  fs/cifs/cifs_unicode.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index b380e087..a2b2355e 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -105,9 +105,6 @@ convert_sfm_char(const __u16 src_char, char *target)
>         case SFM_LESSTHAN:
>                 *target = '<';
>                 break;
> -       case SFM_SLASH:
> -               *target = '\\';
> -               break;
>         case SFM_SPACE:
>                 *target = ' ';
>                 break;
> --
> 2.17.1
>
>
> ===========================================================
> Learn how to protect users, data, and applications with security engineered for the public cloud by Barracuda. http://barracuda.com
>
> DISCLAIMER:
> This e-mail and any attachments to it contain confidential and proprietary material of Barracuda, its affiliates or agents, and is solely for the use of the intended recipient. Any review, use, disclosure, distribution or copying of this transmittal is prohibited except by or on behalf of the intended recipient. If you have received this transmittal in error, please notify the sender and destroy this e-mail and any attachments and all copies, whether electronic or printed.
> ===========================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Thanks,

Steve

===========================================================

Forrester names Barracuda WAF a Strong Performer!

Get the free report here!

https://www.barracuda.com/WAFWave



DISCLAIMER:

This e-mail and any attachments to it contain confidential and proprietary material of Barracuda, its affiliates or agents, and is solely for the use of the intended recipient. Any review, use, disclosure, distribution or copying of this transmittal is prohibited except by or on behalf of the intended recipient. If you have received this transmittal in error, please notify the sender and destroy this e-mail and any attachments and all copies, whether electronic or printed.

===========================================================
