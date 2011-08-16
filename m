From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS can't read share
Date: Tue, 16 Aug 2011 11:35:19 -0500
Message-ID: <CAH2r5mumWMETXL4M2Dj8cd_Z9e0HU3qJyqrU=YFijJGO526JuA@mail.gmail.com>
References: <OFF2DA68D6.9F5E142E-ON862578EE.0055727B-862578EE.00558DE9@jci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFF2DA68D6.9F5E142E-ON862578EE.0055727B-862578EE.00558DE9-zES+1Ur7hjI@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Windows server version? (if you don't know it from the wireshark trace
of sessionsetup - you can view /proc/fs/cifs/DebugData)

Do you have the wireshark trace we could see?

On Tue, Aug 16, 2011 at 10:34 AM,  <Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org> wrot=
e:
> I can mount my Windows share with "mount -t cifs //10.2.8.42/myshare
> /mnt/myshare -o
> user=3DUSER,password=3Dcat,domain=3DWORKGROUP,sec=3Dntlmssp,noserveri=
no". But when
> I try to access the contents of the directory I get "NT Status:
> STATUS_INVALID_LEVEL" according to wireshark.
>
> Is this a known issue? Is there some configuration I need to add to t=
he
> kernel?
>
> Thanks for your help.
>
> Bryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
