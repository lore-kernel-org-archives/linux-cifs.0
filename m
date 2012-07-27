From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ALPHA: advice for a patch to CIFS
Date: Fri, 27 Jul 2012 15:50:20 -0400
Message-ID: <CAFB9KM0NKGFw0rtb3qt41oaufss7OEN9nP0z-amRMis3AWNWmA@mail.gmail.com>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDF8E31455@LONPMAILBOX01.citrite.net>
	<CAFB9KM05gZpoRSQb-QrDrXe0+zPK33k8OzL=Q2WKWWEZTAaLfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM05gZpoRSQb-QrDrXe0+zPK33k8OzL=Q2WKWWEZTAaLfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 27, 2012 at 3:42 PM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
> On Fri, Jul 27, 2012 at 3:13 PM, Frediano Ziglio
> <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Hi,
>>   I'm currently trying to support utf-16 with characters not in plane 0.
>>
>> I'm currently end up with this patch. Currently is not against latest
>> kernel but the problem still reside in last git kernel.
>>
>> wchar_t is currently 16bit so converting a utf8 encoded characters not
>> in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
>> -EINVAL return. This patch detect utf8 in cifs_strtoUCS and add special
>> code calling directly utf8_to_utf32.
>>
>> Does it sound a good patch or just a bad hack. Perhaps would be better
>> to change char2uni converting to unicode_t (32bit) instead of wchar_t
>> but probably many code have to be checked in order to make sure it does
>> not lead to wrong conversions, overflows or other bad stuff.
>>
>> Is it worth working in this hacking way? I'd like to upstream this
>> patch.
>>
>>
>> diff -r c2325d754e8d fs/cifs/cifs_unicode.c
>> --- a/fs/cifs/cifs_unicode.c    Fri Jul 27 15:12:23 2012 +0100
>> +++ b/fs/cifs/cifs_unicode.c    Fri Jul 27 19:09:04 2012 +0100
>> @@ -192,22 +192,40 @@ cifs_strtoUCS(__le16 *to, const char *fr
>>  {
>>         int charlen;
>>         int i;
>> -       wchar_t *wchar_to = (wchar_t *)to; /* needed to quiet sparse */
>> +       int is_utf8 = !strcmp(codepage->charset, "utf8");
>> +       wchar_t wchar_to; /* needed to quiet sparse */
>> +       unicode_t uni;
>>
>>         for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
>>
>>                 /* works for 2.4.0 kernel or later */
>> -               charlen = codepage->char2uni(from, len, &wchar_to[i]);
>> +               if (is_utf8) {
>> +                       charlen = utf8_to_utf32(from, len, &uni);
>> +               } else {
>> +                       charlen = codepage->char2uni(from, len,
>> &wchar_to);
>> +                       uni = wchar_to;
>> +               }
>> +
>>                 if (charlen < 1) {
>>                         cERROR(1,
>>                                ("strtoUCS: char2uni of %d returned %d",
>>                                 (int)*from, charlen));
>>                         /* A question mark */
>> -                       to[i] = cpu_to_le16(0x003f);
>> +                       wchar_to = 0x003f;
>>                         charlen = 1;
>> -               } else
>> -                       to[i] = cpu_to_le16(wchar_to[i]);
>> -
>> +               } else if (uni < 0x10000) {
>> +                       wchar_to = uni;
>> +               } else if (uni < 0x110000) {
>> +                       uni -= 0x10000;
>> +                       to[i++] = cpu_to_le16(0xD800 | (uni >> 10));
>> +                       wchar_to = 0xDC00 | (uni & 0x3FF);
>> +               } else {
>> +                       cERROR(1,
>> +                              ("strtoUCS: char2uni of %d returned %d",
>> +                               (int)*from, charlen));
>> +                       wchar_to = 0x003f;
>> +               }
>> +               to[i] = cpu_to_le16(wchar_to);
>>         }
>>
>>         to[i] = 0;
>>
>> Signed-off-by: "Frediano Ziglio" <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
>>
>> Regards,
>>   Frediano
>>

[sorry for the noise, resending in plain text for the mail daemon - it
rejected the last mail because of HTML formatting]

 Just my $0.02, but there are a lot of magic numbers in this patch.  Maybe I
 don't have the domain knowledge needed to understand the patch, but I do
 have trouble following the conditionals and bitwise operations.

 --
 Peace and Blessings,
 -Scott.
