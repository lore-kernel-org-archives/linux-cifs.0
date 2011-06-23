From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Thu, 23 Jun 2011 09:43:22 -0500
Message-ID: <BANLkTi=T+=yaQ7MH7g+gmqjFgP2HX4iqJg@mail.gmail.com>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local>
	<20110608164415.5b8cbf4b@tlielax.poochiereds.net>
	<7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local>
	<20110622163251.16499f4b@tlielax.poochiereds.net>
	<AC93F84448C9430AB4B791EE591F2F97@dynamicsourcemfg.local>
	<6753F891F47C4E9CBDFB66A63A8E1367@dynamicsourcemfg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shane McColman <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6753F891F47C4E9CBDFB66A63A8E1367-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jun 23, 2011 at 9:09 AM, Shane McColman
<smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
> Adding wsize to fstab did not work. =A0I restarted things at 4:15 yes=
terday
> and in less than hour I was back to the same place.
>
>
> Jun 22 16:15:14 fujimoto kernel: [629641.354375] CIFS VFS: Unexpected=
 lookup
> error -112
> Jun 22 16:15:14 fujimoto kernel: [629641.354383] CIFS VFS: Unexpected=
 lookup
> error -112
> Jun 22 17:08:42 fujimoto kernel: [632843.214260] CIFS VFS: Autodisabl=
ing the
> use of server inode numbers on \\d7gsjxb1\AOI_1 (F). This server does=
n't
> seem to support them properly. Hardlinks will not be recognized on th=
is
> mount. Consider mounting with the "noserverino" option to silence thi=
s
> message.
> Jun 22 17:18:11 fujimoto kernel: [633411.476667] CIFS VFS: Send error=
 in
> read =3D -11
> Jun 22 17:21:11 fujimoto kernel: [633590.919038] CIFS VFS: Send error=
 in
> read =3D -11
> Jun 22 17:23:11 fujimoto kernel: [633710.706852] CIFS VFS: Send error=
 in
> read =3D -11
> Jun 22 17:25:11 fujimoto kernel: [633830.436301] CIFS VFS: Send error=
 in
> read =3D -11
> Jun 22 17:27:41 fujimoto kernel: [633980.129508] CIFS VFS: Send error=
 in
> read =3D -11
> Jun 22 17:28:11 fujimoto kernel: [634010.077463] CIFS VFS: Send error=
 in
> read =3D -11
> Jun 22 17:30:11 fujimoto kernel: [634129.838218] CIFS VFS: Send error=
 in
> read =3D -11
> Jun 22 17:41:10 fujimoto kernel: [634787.992075] CIFS VFS: Send error=
 in
> read =3D -11
>
> When I came in this morning I did an ls on the directory to check it =
and it
> has been 15 minutes and I'm still waiting.
>
>
> Shane McColman PEng.
> Quality Assurance Engineer
> Dynamic Source Manufacturing Inc.
> Calgary AB, Canada
>
> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> [mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shane McColman
> Sent: Wednesday, June 22, 2011 4:40 PM
> To: 'Jeff Layton'
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: CIFS VFS errors
>
> I've restarted things and remounted the drive adding wsize to fstab
>
> //d7gsjxb1/AOI_1\040(F)/AOI\040Data =A0 =A0 /mnt/AOIData =A0 =A0cifs
> rw,_netdev,guest,uid=3D1000,gid=3D100,wsize=3D16384 =A0 0 0
>
> Should have some answers by Monday if not sooner.
>
> Shane McColman PEng.
> Quality Assurance Engineer
> Dynamic Source Manufacturing Inc.
> Calgary AB, Canada
>
> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> [mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jeff Layton
> Sent: Wednesday, June 22, 2011 2:33 PM
> To: Shane McColman
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: CIFS VFS errors
>
> On Wed, 22 Jun 2011 14:12:23 -0600
> "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
>
>> Over the past two days the number of error messages stayed the same =
but
> now
>> I'm getting the same problems as reported in
>>
>> Bug 36952 - =A0[2.6.39] CIFS write failures where 2.6.38 works
>>
>> I had to restart my software this morning, but I'm pretty sure I sho=
uld be
>> back to the same spot by Monday (if not sooner). =A0I can turn on de=
bug
>> logging (as suggested by Jeff in reply to Helge's email) if somebody=
 is
>> interested. =A0Just let me know. =A0I really need to get this fixed,=
 so just
> let
>> me know what I can do to help.
>>
>
> I suspect that the issue is with signed connections. Are you using
> signed authentication? The patch that I posted earlier today should f=
ix
> this in mainline if so.
>
> We'll need to do something different for 2.6.39 though. A possible
> workaround in the meantime is to set the wsize to something smaller, =
eg
> wsize=3D16384. Could you try that and let me know if it makes the pro=
blem
> go away?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

what does command   modinfo cifs   return version of cifs as?
I think Jeff's patches are in 1.69 onwards versions of cifs.
Looks like the requests are timing out which should not be the case.
Do you see reconnects in /proc/fs/cifs/Stats?
