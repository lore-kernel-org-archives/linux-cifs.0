From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 unix extensions
Date: Thu, 19 Jun 2014 09:13:42 -0700
Message-ID: <CAH2r5muP55e-neuG8so_0oiqSedoRxh5wSFo4_EMSvYO-xi+YA@mail.gmail.com>
References: <E1WXtQF-00AjyQ-OL@intern.SerNet.DE> <20140409185259.GE14143@samba2>
 <E1WxISY-004maB-TA@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org" <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1WxISY-004maB-TA-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I generally like this, although I prefer simple one request field, and
the response field to simply match the data we populate in the struct
inode that doesn't already come back in the Windows info (the set of
fields you return is close to what is needed now), and I think that
for the stat case (open file with query of file info returned in unix
context on open response) we don't actually need multiple info levels
(at least for the Linux case) as symlinks can be done any of three
other ways.

On Wed, Jun 18, 2014 at 11:11 AM, Volker Lendecke
<Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:
> On Wed, Apr 09, 2014 at 11:52:59AM -0700, Jeremy Allison wrote:
>
>> > https://git.samba.org/?p=3Dvl/samba.git/.git;a=3Dshortlog;h=3Drefs=
/heads/smb2-unix
>
>> W00t! Working code always trumps everything :-).
>
> The branch contains some updates. A "chown file 1" now ends
> up server-side in a debug message saying
>
> [2014/06/18 14:46:46.344109, 10, pid=3D19107, effective(502, 502), re=
al(502, 502)]
> ../source3/smbd/smb2_create.c:1183(smbd_smb2_create_send)
>   smbd_smb2_create_send: Setting uid to 1
>
> Next step is to actually do the chown server-side :-)
>
> Comments?
>
> Volker
>
> --
> SerNet GmbH, Bahnhofsallee 1b, 37081 G=C3=B6ttingen
> phone: +49-551-370000-0, fax: +49-551-370000-9
> AG G=C3=B6ttingen, HRB 2816, GF: Dr. Johannes Loxen
> http://www.sernet.de, mailto:kontakt-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org



--=20
Thanks,

Steve
