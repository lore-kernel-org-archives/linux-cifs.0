From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs prerequisites
Date: Thu, 18 Aug 2011 12:38:32 -0500
Message-ID: <CADT32e+s58U-jbbggNZKzc4rybybf3p+7+HJ-zvAz+7CHVDskg@mail.gmail.com>
References: <6d15d641caf322cf62917e8b03035fbf.squirrel@alpha.server-room.co.uk>
	<CAH2r5mtTbfz-1v2fTnk4GZ270UBFX4FKW+zP6Hgq=mXvY7jhYA@mail.gmail.com>
	<CADQjK6W4equW=jo4sxHSxr5aUvK5aHaV+3es6+ujV+JTrS576w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bruce-FsTrmwUK8BR2iXbJP1moag@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kong Li <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADQjK6W4equW=jo4sxHSxr5aUvK5aHaV+3es6+ujV+JTrS576w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 18, 2011 at 12:15 PM, Kong Li <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The invalid argument might be a bug on windows 2008 side.
> http://support.microsoft.com/kb/957441
>
> I had the exact same situation. =A0Applying the fix resolved the issu=
e
> in my environment.
>
> Thanks.
>
> Kong
>
>
> On Thu, Aug 18, 2011 at 9:49 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>> the available messages which can be returned on mount are
>> quite limited so sometimes the mapping of network errors
>> on to the very limited set of available mount error
>> messages can get confusing.
>>
>> Do you see mount generating any messages
>> in dmesg? =A0Alternatively, you might turn on cifs debugging
>> (echo 7 > /proc/fs/cifs/cifsFYI) and try mount again
>> and see if the warning message for the mount failure
>> is listed (in dmesg)
>>
>> On Thu, Aug 18, 2011 at 11:31 AM, =A0<bruce-FsTrmwUK8BR2iXbJP1moag@public.gmane.org> wrote:
>>>
>>> Dear List,
>>> I am running a 2.6.28 kernel that I have compiled with cifs filesys=
tem
>>> support. I am trying to mount a share from a windows 2008 server re=
quiring
>>> ntlmv2. when I try to pass the option sec=3Dntlmv2 or ntlmv2i I rec=
eive an
>>> invalid argument message. If I omit the sec option I receive a perm=
ission
>>> denied.
>>> I have also tried to use a stock Debian kernel (2.6.32) that I have
>>> checked to have cifs compiled in and I get the same results. If I p=
erform
>>> a 'modinfo cifs' it shows the module to be loaded and that I am run=
ning
>>> ver 1.61 of cifs.
>>> Is there any other components I need to check (do I need a library =
package
>>> to support ntlmv2??)
>>> I can mount shares of servers that allow NTLMv1.
>>>
>>> Any help gratefully received.
>>>
>>> Thanks Bruce
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Yes, Jeff Layton had pointed to this
 http://support.microsoft.com/kb/957441/en-us
earlier.
