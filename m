From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: CMAC moving to crypto
Date: Sun, 21 Apr 2013 21:17:36 +0000
Message-ID: <614F550557B82C44AC27C492ADA391AA075C8028@TK5EX14MBXC284.redmond.corp.microsoft.com>
References: <CAH2r5msejqQkp=Wkbkim6RyBGrBp5h5neS+cjrJC_W543OY-YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msejqQkp=Wkbkim6RyBGrBp5h5neS+cjrJC_W543OY-YQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve French
> Sent: Thursday, April 18, 2013 10:24 AM
> To: Shirish Pargaonkar; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-technical
> Subject: CMAC moving to crypto
> 
> I see that cmac.c is now in Linux crypto directory, presumably destined for
> 3.11 kernel.  Presumably would allow hardware acceleration for new
> processors which support it in internally ?!
> 
> Has anyone looked at whether and how we could use this (in either kernel or
> samba)

As I'm sure you know, the SMB3 dialect uses AES-CMAC-128 for message signing, so access to the native support of newer processors would benefit Linux SMB3 peers greatly, as it does currently on Windows. Good to see.

Is AES CCM encryption also supported or planned? Because CCM provides integrity, CMAC signing is bypassed for SMB3 encrypted messages.

Tom.


> 
> See:
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-
> next.git/log/crypto/cmac.c
> 
> --
> Thanks,
> 
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
