From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: smb2 logoff
Date: Mon, 5 Aug 2013 17:07:33 +0000
Message-ID: <614F550557B82C44AC27C492ADA391AA1495AC1F@TK5EX14MBXC285.redmond.corp.microsoft.com>
References: <CADT32eKr2K8G58ub50FELC=oh78pmBPDs+Fgpd1=_UqKa4OmmA@mail.gmail.com>
 <20130804211856.7a2f074e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130804211856.7a2f074e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jeff Layton
> Sent: Sunday, August 4, 2013 6:19 PM
> To: Shirish Pargaonkar
> Cc: linux-cifs
> Subject: Re: smb2 logoff
> 
> On Sun, 4 Aug 2013 10:51:44 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > cifs client does not handle error code returned by smb2 session logoff.
> > What if the server returns access denied?
> > I looked in ms-smb2 but it does not say anything about how a client
> > should handle error by smb2 logoff response.

You guys should file a dochelp issue on this. But in general, if the client sends an unsigned request when the server requires a signed one, the request will be failed at the server prior to any processing. If the request is a logoff, that means no logoff occurs.

Tom.

> > This happens when cifs client sends a smb2 logoff request without a
> > signature (because we remove the session from the list before sending
> > off a request and handling the response) and can't verify signature in
> > the response.
> > Also, not sure what happens at the server if the session logoff
> > request is a) unsigned and/or b) server returns error as a response.
> >
> > I think the patch should be to remove the session from the list after
> > the smb2 logoff request is sent and response is handled.
> > Will submit a patch as part of changing per smb connection key to per
> > session key patchset resubmission.
> >
> 
> That sounds like the correct approach to me. The only tricky part is to make
> sure that new references can't be taken on a session that's being torn down.
> 
> I'd suggest making that change as a separate bugfix patch...
> 
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
