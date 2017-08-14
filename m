From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no
 payload
Date: Mon, 14 Aug 2017 18:20:06 +0000
Message-ID: <CY4PR21MB0182366FB8C2EC58B6A77910CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-17-git-send-email-longli@exchange.microsoft.com>
 <20170813102412.GH17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813102412.GH17287-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
> Sent: Sunday, August 13, 2017 3:24 AM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Long Li
> <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: Re: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no
> payload
>=20
> On Wed, Aug 02, 2017 at 01:10:27PM -0700, Long Li wrote:
> > From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> >
> > Implement the function to send a SMBD message with no payload. This is
> required at times when we want to extend credtis to server to have it
> continue to send data, without sending any actual data payload.
>=20
> Shouldn't this just be implemented as a special case in the version that =
posts
> data?

It uses a different packet format "struct smbd_data_transfer_no_data". I ca=
n restructure some common code to share between packet sending functions.
