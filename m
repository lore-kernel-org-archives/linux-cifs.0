From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Possible slab memory corruption while updating
 extended stats
Date: Thu, 3 Feb 2011 14:20:25 -0600
Message-ID: <AANLkTi=BXPPOkG4iH6fmTs=j_KBTEysefZA5tSvUd3a_@mail.gmail.com>
References: <1296762959-24783-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110203151042.6b8469e3@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110203151042.6b8469e3-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 3, 2011 at 2:10 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, =A03 Feb 2011 13:55:59 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Updating extended statistics here can cause slab memory corruption
>> when callback functions frees (mid_entry) slab memory.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 =A03 ---
>> =A01 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 945b220..f3c5ea6 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -635,9 +635,6 @@ multi_t2_fnd:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entr=
y->midState =3D MID_RESPONSE_RECEIVED;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del=
_init(&mid_entry->qhead);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entr=
y->callback(mid_entry);
>> -#ifdef CONFIG_CIFS_STATS2
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry-=
>when_received =3D jiffies;
>> -#endif
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D NULL;
>> --
>> 1.6.0.2
>>
>
>
> Good catch.
>
> Would it be better to move this up above the call to "callback" inste=
ad
> of eliminating it? I'm not so sure about the value of those stats, bu=
t
> it seems like they'll be wrong if you eliminate those lines altogethe=
r.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Yes, I think so. Let me repost the patch by moving the stat2 update to
when_received couple of lines above.
