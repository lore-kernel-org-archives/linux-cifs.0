From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server resources"
Date: Wed, 28 Sep 2011 04:30:56 -0500
Message-ID: <CADT32eLk5N4WJCMdtcd3MTgR39fCTn4_gQqqobYsxkpcPnfuDQ@mail.gmail.com>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 27, 2011 at 4:36 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> FYI - The cifs async write in 3.0 seems to exacerbate problems runnin=
g
> out of memory (apparently) on the Windows 7 system (running as a
> server) after a large file copy to the server completes. =A0 I have b=
een
> able to reproduce the same problem on Windows Vista Service Pack 2
> (which is a good news/bad news story since my earlier testing on
> Windows Vista showed hangs on some requests rather than returning out
> of memory). =A0Does not seem to be a problem with any of the Windows
> server versions just Windows 7 and Vista so far

If this is a problem with Windows Vista and Windows 7, it is likely
to be a problem with Windows 2008 Server as well.
Basically Windows server starting Vista perhaps?

>
> As Pavel noted in an earlier note, increasing MaxWorkItems to 4096 in
> the Windows registry solves this.
>
> The cifs async write code does increase large file copy speed
> dramatically (more than 15% in most environments) - but we are workin=
g
> through how to handle the Windows7/WindowsVista problem to see if
> there are workarounds.
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
