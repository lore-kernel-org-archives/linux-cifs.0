From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] SMB2: Enforce sec= mount option
Date: Thu, 08 Dec 2016 14:33:20 +0530
Message-ID: <1481187800.4195.19.camel@redhat.com>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com>
         <CAFB9KM0oPPm4bYyKd75Yjy-2kCZ=0UTpwn=ONCRo0g5waNa6AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM0oPPm4bYyKd75Yjy-2kCZ=0UTpwn=ONCRo0g5waNa6AA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2016-12-08 at 02:06 -0600, Scott Lovenberg wrote:
> On Thu, Dec 8, 2016 at 12:46 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > 
> > If the security type specified using a mount option is not
> > supported,
> > the SMB2 session setup code changes the security type to
> > RawNTLMSSP. We
> > should instead fail the mount and return an error.
> > 
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/smb2pdu.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 5ca5ea46..e66fad6 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -955,7 +955,8 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct
> > SMB2_sess_data *sess_data)
> >  static int
> >  SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data
> > *sess_data)
> >  {
> > -       if (ses->sectype != Kerberos && ses->sectype != RawNTLMSSP)
> > +       /* Default sec type is set to RawNTLMSSP */
> > +       if (ses->sectype == Unspecified)
> >                 ses->sectype = RawNTLMSSP;
> > 
> >         switch (ses->sectype) {
> > --
> > 2.7.4
> > 
> > --
> 
> My initial reaction was "allow the SSP to do its thing".  However,
> after some consideration, this is a much better way to handle this
> exceptional case when a user gives an explicit security type and it
> cannot be honored.  +1, FWIW
> My only concern is, "will this be considered a regression by users
> that have (unknowingly) relied upon the previous behavior?"
> 
That is a valid concern which could trip up users who have been using
an incorrect mount option. However in my opinion it would be better to
reject mounts in case where the mount options requested are not
available instead of silently switching the mount options and ending up
with behaviour which wasn't expected by the user.

Sachin Prabhu
