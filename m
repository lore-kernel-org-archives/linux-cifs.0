From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] SMB2: Enforce sec= mount option
Date: Wed, 11 Jan 2017 17:47:51 +0530
Message-ID: <1484137071.29387.9.camel@redhat.com>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com>
         <CAFB9KM0oPPm4bYyKd75Yjy-2kCZ=0UTpwn=ONCRo0g5waNa6AA@mail.gmail.com>
         <1481187800.4195.19.camel@redhat.com>
         <c0748fb1-4161-ea0f-3f6d-b0705bb83a9d@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c0748fb1-4161-ea0f-3f6d-b0705bb83a9d-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2017-01-11 at 11:45 +0000, Germano Percossi wrote:
> Hi,
> 
> My 2 cents.
> 
> Everything depends on the interpretation given to the sec option.
> If it is interpreted like "this is what I want" then, yes, this patch
> does the right thing.
> 
> But if it is interpreted as "this is what I prefer" then, rejecting
> the
> mount is not the right thing and will be seen as a regression.
> 
> The latter interpretation is not so uncommon, given there is not an
> easy
> way to ask the kernel what is the default negotiation protocol and
> there
> is not a way to blacklist protocols.

My own opinion is that when a mount option is explicitly passed, it is
expected the option provided be used and fail if it cannot be used. I
think replacing a explicitly requested mount option with another can
lead to unexpected results and may also affect things activities like
testing.

There are other mount options like "vers=" where cifs doesn't attempt
to replace an invalid protocol version with another. This in my opinion
is the correct behaviour.

Steve, What is your opinion on this?

Sachin Prabhu

> 
> I planned to implement a blacklist mechanism (along with a preference
> list) but it is overkill for the present purpose.
> 
> My suggestion is to add an additional boolean to make this option
> strict, so it would be possible to let old code use sec as a
> suggestion while others can start adding the boolean if they prefer
> failures over silent changes.
> 
> Obviously, this requires changes in doc and mount.cifs but could save
> some headaches.
> 
> Regards,
> Germano
> 
> On 12/08/2016 09:03 AM, Sachin Prabhu wrote:
> > On Thu, 2016-12-08 at 02:06 -0600, Scott Lovenberg wrote:
> > > On Thu, Dec 8, 2016 at 12:46 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org
> > > m>
> > > wrote:
> > > > 
> > > > If the security type specified using a mount option is not
> > > > supported,
> > > > the SMB2 session setup code changes the security type to
> > > > RawNTLMSSP. We
> > > > should instead fail the mount and return an error.
> > > > 
> > > > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >  fs/cifs/smb2pdu.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > > index 5ca5ea46..e66fad6 100644
> > > > --- a/fs/cifs/smb2pdu.c
> > > > +++ b/fs/cifs/smb2pdu.c
> > > > @@ -955,7 +955,8 @@
> > > > SMB2_sess_auth_rawntlmssp_authenticate(struct
> > > > SMB2_sess_data *sess_data)
> > > >  static int
> > > >  SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data
> > > > *sess_data)
> > > >  {
> > > > -       if (ses->sectype != Kerberos && ses->sectype !=
> > > > RawNTLMSSP)
> > > > +       /* Default sec type is set to RawNTLMSSP */
> > > > +       if (ses->sectype == Unspecified)
> > > >                 ses->sectype = RawNTLMSSP;
> > > > 
> > > >         switch (ses->sectype) {
> > > > --
> > > > 2.7.4
> > > > 
> > > > --
> > > 
> > > My initial reaction was "allow the SSP to do its
> > > thing".  However,
> > > after some consideration, this is a much better way to handle
> > > this
> > > exceptional case when a user gives an explicit security type and
> > > it
> > > cannot be honored.  +1, FWIW
> > > My only concern is, "will this be considered a regression by
> > > users
> > > that have (unknowingly) relied upon the previous behavior?"
> > > 
> > 
> > That is a valid concern which could trip up users who have been
> > using
> > an incorrect mount option. However in my opinion it would be better
> > to
> > reject mounts in case where the mount options requested are not
> > available instead of silently switching the mount options and
> > ending up
> > with behaviour which wasn't expected by the user.
> > 
> > Sachin Prabhu
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
