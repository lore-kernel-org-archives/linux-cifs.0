From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: Samba server problem with validate negotiate info fsctl?
Date: Tue, 19 Nov 2013 16:13:35 +0000
Message-ID: <b9fd9f8e96e443c9a443d98b2f691bfa@BLUPR03MB328.namprd03.prod.outlook.com>
References: <CAH2r5mt6Qk7mZkmwtQk0ZO2L9emMc90-Zts-N2=o=1rx_YmGUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt6Qk7mZkmwtQk0ZO2L9emMc90-Zts-N2=o=1rx_YmGUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve French
> Sent: Monday, November 18, 2013 6:55 PM
> To: samba-technical; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Samba server problem with validate negotiate info fsctl?
> 
> With the kernel patch I recently submitted to list for review,  tried the
> validate negotiate info fsctl (unsigned) on an smb3.0 mount against Windows
> 8.1 server and it failed, dropping the connection immediately.  I repeated it
> with "sign" mount option and it worked fine.
> 
> Trying the validate negotiate info fsctl against Samba though it worked fine
> with signing disabled implying that the server is not checking to make sure
> that that request is signed (the validate negotiate info fsctl is always
> supposed to be signed right?)

Indeed yes - and signing the validate negotiate is important to ensure it's not tampered with by a MITM attacker. The MS-SMB2 document makes the client requirement in section 3.2.5.5 (emphasis added):

"If MaxDialect is "3.000" or "3.002", and RequireSecureNegotiate is TRUE, the client MUST validate the SMB2 NEGOTIATE messages originally sent on this connection by sending a *signed* VALIDATE_NEGOTIATE_INFO request as specified in section 2.2.31.4. "

Note that "MaxDialect" is the highest dialect the client is capable of, not necessarily the dialect negotiated on the connection. This too is important, to detect a negotiation downgrade by a MITM. Since the server will sign its response, even a failure can be used to complete the validation.
