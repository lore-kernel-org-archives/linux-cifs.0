From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] Convert properly UTF-8 to UTF-16
Date: Wed, 3 Oct 2012 14:49:52 -0500
Message-ID: <CAH2r5msLxJVTwVrD9vs8ZOjQdRpbVyhZus4V6Su-Y8-hT229Ug@mail.gmail.com>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08D16@LONPMAILBOX01.citrite.net>
	<20120807064752.22e0da81@corrin.poochiereds.net>
	<7CE799CC0E4DE04B88D5FDF226E18AC2E07634EB82@LONPMAILBOX01.citrite.net>
	<7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408DA@LONPMAILBOX01.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408DA-aFusIB7tbcLeU4JHVX8hdHnr0TU713UqXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged - but doesn't the reverse also have to be added in cifs_from_utf16?  ie

          utf16s_to_utf8s(uni, ... );

I am glad that someone added these multiword handling routines into
the kernel for FAT - this has been something we have wanted for a long
time in cifs (and smb2/smb3).  Note the comment in
fs/cifs/cifs_unicode.c

/ * Note that some windows versions actually send multiword UTF-16 characters
 * instead of straight UTF16-2. The linux nls routines however aren't able to
 * deal with those characters properly. In the event that we get some of
 * those characters, they won't be translated properly.
 */
int
cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
                 const struct nls_table *codepage, bool mapchar)


We could really use some nls test cases for cifs/smb2/smb3/nfs4 which
basically did various file, directory, symlink create/rename/delete
operations with various hard to map characters so we can test copying
to and from the server and ensure that we get the name mappings right
for these (and don't ever regress).   Fortunately smb2/smb3 is only
unicode so we don't have to deal with mappings to other codepages from
utf8

On Wed, Oct 3, 2012 at 9:34 AM, Frediano Ziglio
<frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2012-08-07 at 06:47 -0400, Jeff Layton wrote:
>> On Tue, 7 Aug 2012 10:33:03 +0100
>> Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> >
>> > wchar_t is currently 16bit so converting a utf8 encoded characters
> not
>> > in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead
> to a
>> > -EINVAL return. This patch detect utf8 in cifs_strtoUTF16 and add
> special
>> > code calling utf8s_to_utf16s.
>> >
>> > Signed-off-by: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  fs/cifs/cifs_unicode.c |   22 ++++++++++++++++++++++
>> >  1 files changed, 22 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
>> > index 7dab9c0..1166b95 100644
>> > --- a/fs/cifs/cifs_unicode.c
>> > +++ b/fs/cifs/cifs_unicode.c
>> > @@ -203,6 +203,27 @@ cifs_strtoUTF16(__le16 *to, const char *from,
> int len,
>> >     int i;
>> >     wchar_t wchar_to; /* needed to quiet sparse */
>> >
>> > +   /* special case for utf8 to handle no plane0 chars */
>> > +   if (!strcmp(codepage->charset, "utf8")) {
>> > +           /*
>> > +            * convert utf8 -> utf16, we assume we have enough space
>> > +            * as caller should have assumed conversion does not
> overflow
>> > +            * in destination len is length in wchar_t units
> (16bits)
>> > +            */
>> > +           i  = utf8s_to_utf16s(from, len, UTF16_LITTLE_ENDIAN,
>> > +                                  (wchar_t *) to, len);
>> > +
>> > +           /* if success terminate and exit */
>> > +           if (i >= 0)
>> > +                   goto success;
>> > +           /*
>> > +            * if fails fall back to UCS encoding as this
>> > +            * function should not return negative values
>> > +            * currently can fail only if source contains
>> > +            * invalid encoded characters
>> > +            */
>> > +   }
>> > +
>> >     for (i = 0; len && *from; i++, from += charlen, len -= charlen)
> {
>> >             charlen = codepage->char2uni(from, len, &wchar_to);
>> >             if (charlen < 1) {
>> > @@ -215,6 +236,7 @@ cifs_strtoUTF16(__le16 *to, const char *from,
> int len,
>> >             put_unaligned_le16(wchar_to, &to[i]);
>> >     }
>> >
>> > +success:
>> >     put_unaligned_le16(0, &to[i]);
>> >     return i;
>> >  }
>>
>> Looks reasonable...
>>
>> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Steve, could you consider my patch for inclusion into Linux?
>
> Thanks,
>   Frediano
>



-- 
Thanks,

Steve
