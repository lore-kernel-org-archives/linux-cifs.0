From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Fix to convert SURROGATE PAIR filename
Date: Wed, 20 May 2015 13:14:14 -0500
Message-ID: <CAH2r5munzrZOYLds+tUNVh7XanzSW51dK9S7XjEtQoSxCA9Vbg@mail.gmail.com>
References: <54D1C8EE.2030900@nttcom.co.jp> <CAH2r5ms-qB=MAxsk_CQAaLBcNK0a+c9VkDdZMV4wEXPvBBbQGA@mail.gmail.com>
 <552B54B2.6000102@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552B54B2.6000102-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Mon, Apr 13, 2015 at 12:31 AM, Nakajima Akira
<nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
> On 2015/04/07 11:20, Steve French wrote:
>> Note build warnings (when running normal sparse checks during compile)
>> looks like need to resolve endian errors so that this is sure to work
>> in big endian, not just little endian boxes
>>
>> e.g.
>>
>> make C=1 M=fs/cifs modules CF=-D__CHECK_ENDIAN__
>>
>>   CHECK   fs/cifs/cifs_unicode.c
>> fs/cifs/cifs_unicode.c:508:34: warning: incorrect type in assignment
>> (different base types)
>> fs/cifs/cifs_unicode.c:508:34:    expected restricted __le16
>> [assigned] [usertype] dst_char
>> fs/cifs/cifs_unicode.c:508:34:    got unsigned short [unsigned]
>> [short] [usertype] <noident>
>> fs/cifs/cifs_unicode.c:517:42: warning: incorrect type in assignment
>> (different base types)
>> fs/cifs/cifs_unicode.c:517:42:    expected restricted __le16
>> [assigned] [usertype] dst_char
>> fs/cifs/cifs_unicode.c:517:42:    got unsigned short [unsigned]
>> [short] [usertype] <noident>
>> fs/cifs/cifs_unicode.c:523:42: warning: incorrect type in assignment
>> (different base types)
>> fs/cifs/cifs_unicode.c:523:42:    expected restricted __le16
>> [assigned] [usertype] dst_char
>> fs/cifs/cifs_unicode.c:523:42:    got unsigned short [unsigned]
>> [short] [usertype] <noident>
>> fs/cifs/cifs_unicode.c:526:42: warning: incorrect type in assignment
>> (different base types)
>> fs/cifs/cifs_unicode.c:526:42:    expected restricted __le16
>> [assigned] [usertype] dst_char
>> fs/cifs/cifs_unicode.c:526:42:    got unsigned short [unsigned]
>> [short] [usertype] <noident>
>>
>> On Wed, Feb 4, 2015 at 1:23 AM, Nakajima Akira
>> <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
>>> Garbled characters happen by using surrogate pair for filename.
>>>   (replace each 1 character to ??)
>>>
>>> This causes
>>> -- inode number duplication (when ?? and ?? exist) .
>>> -- can't remove file, directory.
>>> -- can't operate under directory.
>>> -- auto-remount with noserverino.
>>>
>>>
>>> [Steps to Reproduce]
>>> client# touch $(echo -e '\xf0\x9d\x9f\xa3')
>>> client# touch $(echo -e '\xf0\x9d\x9f\xa4')
>>> client# ls -li
>>>   You see same inode number, same filename(=?? and ??) .
>>>
>>>
>>>
>>> [BUG description]
>>> Some functions do not consider about surrogate pair (and IVS).
>>>
>>> cifs_utf16_bytes()
>>> -- return incorrect length, because of not considering about surrogate pair.
>>>    This causes problem about SymbolicLink with surrogate pair filename.
>>>
>>> cifs_mapchar()
>>> -- not considering about surrogate pair.
>>>
>>> cifs_from_utf16()
>>> -- not convert surrogate pair from SMB response (from UTF-16 to UTF-8)
>>>    , then ls shows garbled characters.
>>>
>>> cifsConvertToUTF16()
>>> -- not convert surrogate pair when mapchars(SFM/SFU).
>
>
> I fixed endian bug by using function cpu_to_le16().
> But I don't have Big Endian machine.
> Could someone check on Big Endian machine?
>
>   I'm trying pearpc(PowerPC Emulator), but pearpc doesn't work.
>     (pearpc need yaboot?)
>
> [Procedure]
> client# touch `printf '\xf0\x9d\x9f\xa3'`
> client# touch `printf '\xf0\x9d\x9f\xa4'`
> client# ls -li
>
> --Before patch
> You see same inode number, same filename(=?? and ??) .
>
> --After patch
> You see correct inode numbers, correct filenames(look like 1 and 2)
>
>
> >From 4b0db586e09916a88ac2ac7a1714e52c28781ff6 Mon Sep 17 00:00:00 2001
> From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
> Date: Thu, 9 Apr 2015 17:27:39 +0900
> Subject: [PATCH] Fix to convert SURROGATE PAIR
>
> Garbled characters happen by using surrogate pair for filename.
>   (replace each 1 character to ??)
>
> [Steps to Reproduce for bug]
> client# touch $(echo -e '\xf0\x9d\x9f\xa3')
> client# touch $(echo -e '\xf0\x9d\x9f\xa4')
> client# ls -li
>   You see same inode number, same filename(=?? and ??) .
>
> Fix the bug about these functions do not consider about surrogate pair (and IVS).
> cifs_utf16_bytes()
> cifs_mapchar()
> cifs_from_utf16()
> cifsConvertToUTF16()
>
>
> Reported-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
> Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
>
> ---
>  fs/cifs/cifs_unicode.c |  182 ++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 136 insertions(+), 46 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 0303c67..5a53ac6 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -27,41 +27,6 @@
>  #include "cifsglob.h"
>  #include "cifs_debug.h"
>
> -/*
> - * cifs_utf16_bytes - how long will a string be after conversion?
> - * @utf16 - pointer to input string
> - * @maxbytes - don't go past this many bytes of input string
> - * @codepage - destination codepage
> - *
> - * Walk a utf16le string and return the number of bytes that the string will
> - * be after being converted to the given charset, not including any null
> - * termination required. Don't walk past maxbytes in the source buffer.
> - */
> -int
> -cifs_utf16_bytes(const __le16 *from, int maxbytes,
> -               const struct nls_table *codepage)
> -{
> -       int i;
> -       int charlen, outlen = 0;
> -       int maxwords = maxbytes / 2;
> -       char tmp[NLS_MAX_CHARSET_SIZE];
> -       __u16 ftmp;
> -
> -       for (i = 0; i < maxwords; i++) {
> -               ftmp = get_unaligned_le16(&from[i]);
> -               if (ftmp == 0)
> -                       break;
> -
> -               charlen = codepage->uni2char(ftmp, tmp, NLS_MAX_CHARSET_SIZE);
> -               if (charlen > 0)
> -                       outlen += charlen;
> -               else
> -                       outlen++;
> -       }
> -
> -       return outlen;
> -}
> -
>  int cifs_remap(struct cifs_sb_info *cifs_sb)
>  {
>         int map_type;
> @@ -155,10 +120,13 @@ convert_sfm_char(const __u16 src_char, char *target)
>   * enough to hold the result of the conversion (at least NLS_MAX_CHARSET_SIZE).
>   */
>  static int
> -cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
> +cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
>              int maptype)
>  {
>         int len = 1;
> +       __u16 src_char;
> +
> +       src_char = *from;
>
>         if ((maptype == SFM_MAP_UNI_RSVD) && convert_sfm_char(src_char, target))
>                 return len;
> @@ -168,10 +136,23 @@ cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
>
>         /* if character not one of seven in special remap set */
>         len = cp->uni2char(src_char, target, NLS_MAX_CHARSET_SIZE);
> -       if (len <= 0) {
> -               *target = '?';
> -               len = 1;
> -       }
> +       if (len <= 0)
> +               goto surrogate_pair;
> +
> +       return len;
> +
> +surrogate_pair:
> +       /* convert SURROGATE_PAIR and IVS */
> +       if (strcmp(cp->charset, "utf8"))
> +               goto unknown;
> +       len = utf16s_to_utf8s(from, 3, UTF16_LITTLE_ENDIAN, target, 6);
> +       if (len <= 0)
> +               goto unknown;
> +       return len;
> +
> +unknown:
> +       *target = '?';
> +       len = 1;
>         return len;
>  }
>
> @@ -206,7 +187,7 @@ cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
>         int nullsize = nls_nullsize(codepage);
>         int fromwords = fromlen / 2;
>         char tmp[NLS_MAX_CHARSET_SIZE];
> -       __u16 ftmp;
> +       __u16 ftmp[3];          /* ftmp[3] = 3array x 2bytes = 6bytes UTF-16 */
>
>         /*
>          * because the chars can be of varying widths, we need to take care
> @@ -217,9 +198,17 @@ cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
>         safelen = tolen - (NLS_MAX_CHARSET_SIZE + nullsize);
>
>         for (i = 0; i < fromwords; i++) {
> -               ftmp = get_unaligned_le16(&from[i]);
> -               if (ftmp == 0)
> +               ftmp[0] = get_unaligned_le16(&from[i]);
> +               if (ftmp[0] == 0)
>                         break;
> +               if (i + 1 < fromwords)
> +                       ftmp[1] = get_unaligned_le16(&from[i + 1]);
> +               else
> +                       ftmp[1] = 0;
> +               if (i + 2 < fromwords)
> +                       ftmp[2] = get_unaligned_le16(&from[i + 2]);
> +               else
> +                       ftmp[2] = 0;
>
>                 /*
>                  * check to see if converting this character might make the
> @@ -234,6 +223,17 @@ cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
>                 /* put converted char into 'to' buffer */
>                 charlen = cifs_mapchar(&to[outlen], ftmp, codepage, map_type);
>                 outlen += charlen;
> +
> +               /* charlen (=bytes of UTF-8 for 1 character)
> +                * 4bytes UTF-8(surrogate pair) is charlen=4
> +                *   (4bytes UTF-16 code)
> +                * 7-8bytes UTF-8(IVS) is charlen=3+4 or 4+4
> +                *   (2 UTF-8 pairs divided to 2 UTF-16 pairs) */
> +               if (charlen == 4)
> +                       i++;
> +               else if (charlen >= 5)
> +                       /* 5-6bytes UTF-8 */
> +                       i += 2;
>         }
>
>         /* properly null-terminate string */
> @@ -296,6 +296,46 @@ success:
>  }
>
>  /*
> + * cifs_utf16_bytes - how long will a string be after conversion?
> + * @utf16 - pointer to input string
> + * @maxbytes - don't go past this many bytes of input string
> + * @codepage - destination codepage
> + *
> + * Walk a utf16le string and return the number of bytes that the string will
> + * be after being converted to the given charset, not including any null
> + * termination required. Don't walk past maxbytes in the source buffer.
> + */
> +int
> +cifs_utf16_bytes(const __le16 *from, int maxbytes,
> +               const struct nls_table *codepage)
> +{
> +       int i;
> +       int charlen, outlen = 0;
> +       int maxwords = maxbytes / 2;
> +       char tmp[NLS_MAX_CHARSET_SIZE];
> +       __u16 ftmp[3];
> +
> +       for (i = 0; i < maxwords; i++) {
> +               ftmp[0] = get_unaligned_le16(&from[i]);
> +               if (ftmp[0] == 0)
> +                       break;
> +               if (i + 1 < maxwords)
> +                       ftmp[1] = get_unaligned_le16(&from[i + 1]);
> +               else
> +                       ftmp[1] = 0;
> +               if (i + 2 < maxwords)
> +                       ftmp[2] = get_unaligned_le16(&from[i + 2]);
> +               else
> +                       ftmp[2] = 0;
> +
> +               charlen = cifs_mapchar(tmp, ftmp, codepage, NO_MAP_UNI_RSVD);
> +               outlen += charlen;
> +       }
> +
> +       return outlen;
> +}
> +
> +/*
>   * cifs_strndup_from_utf16 - copy a string from wire format to the local
>   * codepage
>   * @src - source string
> @@ -409,10 +449,15 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
>         char src_char;
>         __le16 dst_char;
>         wchar_t tmp;
> +       wchar_t *wchar_to;      /* UTF-16 */
> +       int ret;
> +       unicode_t u;
>
>         if (map_chars == NO_MAP_UNI_RSVD)
>                 return cifs_strtoUTF16(target, source, PATH_MAX, cp);
>
> +       wchar_to = kzalloc(6, GFP_KERNEL);
> +
>         for (i = 0; i < srclen; j++) {
>                 src_char = source[i];
>                 charlen = 1;
> @@ -441,11 +486,55 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
>                          * if no match, use question mark, which at least in
>                          * some cases serves as wild card
>                          */
> -                       if (charlen < 1) {
> -                               dst_char = cpu_to_le16(0x003f);
> -                               charlen = 1;
> +                       if (charlen > 0)
> +                               goto ctoUTF16;
> +
> +                       /* convert SURROGATE_PAIR */
> +                       if (strcmp(cp->charset, "utf8") || !wchar_to)
> +                               goto unknown;
> +                       if (*(source + i) & 0x80) {
> +                               charlen = utf8_to_utf32(source + i, 6, &u);
> +                               if (charlen < 0)
> +                                       goto unknown;
> +                       } else
> +                               goto unknown;
> +                       ret  = utf8s_to_utf16s(source + i, charlen,
> +                                              UTF16_LITTLE_ENDIAN,
> +                                              wchar_to, 6);
> +                       if (ret < 0)
> +                               goto unknown;
> +
> +                       i += charlen;
> +                       dst_char = cpu_to_le16(*wchar_to);
> +                       if (charlen <= 3)
> +                               /* 1-3bytes UTF-8 to 2bytes UTF-16 */
> +                               put_unaligned(dst_char, &target[j]);
> +                       else if (charlen == 4) {
> +                               /* 4bytes UTF-8(surrogate pair) to 4bytes UTF-16
> +                                * 7-8bytes UTF-8(IVS) divided to 2 UTF-16
> +                                *   (charlen=3+4 or 4+4) */
> +                               put_unaligned(dst_char, &target[j]);
> +                               dst_char = cpu_to_le16(*(wchar_to + 1));
> +                               j++;
> +                               put_unaligned(dst_char, &target[j]);
> +                       } else if (charlen >= 5) {
> +                               /* 5-6bytes UTF-8 to 6bytes UTF-16 */
> +                               put_unaligned(dst_char, &target[j]);
> +                               dst_char = cpu_to_le16(*(wchar_to + 1));
> +                               j++;
> +                               put_unaligned(dst_char, &target[j]);
> +                               dst_char = cpu_to_le16(*(wchar_to + 2));
> +                               j++;
> +                               put_unaligned(dst_char, &target[j]);
>                         }
> +                       continue;
> +
> +unknown:
> +                       dst_char = cpu_to_le16(0x003f);
> +                       charlen = 1;
>                 }
> +
> +ctoUTF16:
>                 /*
>                  * character may take more than one byte in the source string,
>                  * but will take exactly two bytes in the target string
> @@ -456,6 +545,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
>
>  ctoUTF16_out:
>         put_unaligned(0, &target[j]); /* Null terminate target unicode string */
> +       kfree(wchar_to);
>         return j;
>  }
>
> --
> 1.7.1
>
>
>



-- 
Thanks,

Steve
