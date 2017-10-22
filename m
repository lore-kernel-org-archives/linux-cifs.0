From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/2] SMB: fix leak of validate negotiate info response
 buffer
Date: Sun, 22 Oct 2017 16:16:37 +0200
Message-ID: <20171022161637.18103cc1@suse.de>
References: <20171020102033.22936-1-shuwang@redhat.com>
        <20171020124938.9913-1-ddiss@suse.de>
        <20171020124938.9913-2-ddiss@suse.de>
        <61197467.18033621.1508554198404.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <61197467.18033621.1508554198404.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Shu Wang,

On Fri, 20 Oct 2017 22:49:58 -0400 (EDT), Shu Wang wrote:

> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -648,7 +648,7 @@ int smb3_validate_negotiate(const unsigned int xid,
> > struct cifs_tcon *tcon)
> >  {
> >  	int rc = 0;
> >  	struct validate_negotiate_info_req vneg_inbuf;
> > -	struct validate_negotiate_info_rsp *pneg_rsp;
> > +	struct validate_negotiate_info_rsp *pneg_rsp = NULL;
> >  	u32 rsplen;
> >  	u32 inbuflen; /* max of 4 dialects */
> >    
> 
> SMB2_ioctl will set pneg_rsp pointer to NULL, so it won't really
> cause any issue. Anyway, looks good to me.

Yeah, this hunk is unnecessary, but thought it might be helpful if
someone in future wants to jump to the error path prior to the
SMB2_ioctl() call. @Steve: feel free to drop it if you prefer.

Cheers, David
