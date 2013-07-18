From: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cifs: extend the buffer length enought for sprintf()
 using
Date: Thu, 18 Jul 2013 09:31:51 +0800
Message-ID: <51E74587.6000006@asianux.com>
References: <51E5E9DA.8020603@asianux.com> <CADT32e+Ydg5N8uWyvCKee8n4iS34LcCFgE1nrC2S8bq7GnA-hg@mail.gmail.com> <20130717072431.5d8a22b3@tlielax.poochiereds.net> <51E73F1E.4010804@asianux.com> <20130717212559.71b7af06@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130717212559.71b7af06-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/18/2013 09:25 AM, Jeff Layton wrote:
> On Thu, 18 Jul 2013 09:04:30 +0800
> Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>> > On 07/17/2013 07:24 PM, Jeff Layton wrote:
>>> > > On Tue, 16 Jul 2013 22:47:35 -0500
>>> > > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> > > 
>>>> > >> nitpicking...
>>>> > >>
>>>> > >> Should it be MAX_CIFS_DOMAINNAME instead of MAX_CIF_DOMAINNAME,
>>>> > >> unless CIF is short for something here?
>>>> > >>
>>>> > >> Regards,
>>>> > >>
>>>> > >> Shirish
>>>> > >>
>>> > > 
>>> > > Even better...
>>> > > 
>>> > > We already have a MAX_USERNAME_SIZE. Maybe call it MAX_DOMAINNAME_SIZE
>>> > > for parity with that? Might also want to relocate the #define next to
>>> > > that one since it would be helpful to have all of those lengths grouped
>>> > > in the same place.
>>> > > 
>> > 
>> > It sounds reasonable: use MAX_DOMAINNAME_SIZE instead of
>> > MAX_CIFS_DOMAINNAME.
>> > 
>> > 
>>>> > >> On Tue, Jul 16, 2013 at 7:48 PM, Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org> wrote:
>>>>> > >>> For cifs_set_cifscreds() in "fs/cifs/connect.c", 'desc' buffer length
>>>>> > >>> is 'CIFSCREDS_DESC_SIZE' (56 is less than 256), and 'ses->domainName'
>>>>> > >>> length may be "255 + '\0'".
>>>>> > >>>
>>>>> > >>> The related sprintf() may cause memory overflow, so need extend related
>>>>> > >>> buffer enough to hold all things.
>>>>> > >>>
>>> > > 
>>> > > Good catch...
>>> > > 
>>> > > Maybe it would be good to go ahead and turn that sprintf() into a
>>> > > snprintf() too?
>>> > > 
>> > 
>> > Hmm... sprintf() declares to code readers, in current condition, we want
>> > to print all source information without any truncation.
>> > 
>> > So if we know the source max length precisely, we'd better to allocate
>> > the related buffer to print them all instead of use snprintf().
>> > 
>> > If we do not know the source max length precisely or we have to limit
>> > the destination length, we need use snprintf() to fit with destination
>> > max length (declare to the code readers, the source information may be
>> > truncated).
>> > 
>> > 
> Fair enough. It was more of a suggestion for defensive coding. But
> since we know the length of both buffers and that the source is NULL
> terminated, then sprintf is fine.
> 
> Patch looks fine to me otherwise.
> 
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> 

Thank you for your Acked-by.

If possible, I will/should wait a day, if no another additional
suggestions or completions, I should send patch v2 tomorrow.


Thanks.
-- 
Chen Gang
