From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3"
Date: Fri, 01 Sep 2017 15:11:59 +1200
Message-ID: <1504235519.8023.87.camel@samba.org>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
         <59A8A3E2.40804@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "L. A. Walsh" <linux-cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>,
        Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <59A8A3E2.40804-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2017-08-31 at 17:03 -0700, L. A. Walsh wrote:
> Thorsten Leemhuis wrote:
> > This reverts commit eef914a9eb5eb83e60eb498315a491cd1edc13a1 (
> > [SMB3] Improve security, move default dialect to SMB3 from old
> > CIFS), 
> > as it confuses users: https://bugzilla.kernel.org/show_bug.cgi?id=1
> > 96599
> > 
> > It was a patch to improve security by switching to SMB3 by default
> > and
> > support SMB1 (aka CIFS) only when explicitly requested, as the
> > latter
> > is not considered secure anymore (see below for details). This is
> > one of
> > the rare cases where regressions are unavoidable and accepted in
> > Linux.
> >   
> 
> ----
>     Why not SMB2.1?  Win7 is still in support and getting security
> updates.
> MS has not issued any updates for Win7 upgrading it to SMB3.0 for any
> reason (that I'm aware of) -- including security. 
> 
>     If there were security problems in Win7 w/SMB2.1, wouldn't MS
> issue patches -- as they did for WinXP just recently for a severe
> SMB1 bug?

To be clear, the issue with SMB1 is lack of integrity protection, in
particular on the negotiation, where a client may come to think it had
to use NTLM(v2) to talk to the server. 

The only protection available on SMB1 is 'smb signing', which is after
the negotiation of the authentication protocols etc.

>     Seems like if they are willing to patch "out of support" XP, for
> a serious problem, then they would be more likely to patch Win7 for
> lesser problems.
> 
>     Seems like jumping the default to MS's latest and greatest puts
> linux on MS's OS-release schedule -- especially when they haven't
> declared
> SMB2.1 as "bad"...  From what I understand, most of the new security
> features in 3.0 when into SMB2.1 or 2.0.

Sadly 'most' turned out not to be good enough to actually secure the
negotiation, which is the main weakness.   If a change is to be made, I
think it should move up to SMB3. 

In terms of Windows versions, Windows 2012R2 is quite popular these
days, even if Windows 8.1 still wasn't a great hit. 

Finally, I do agree that the move from SMB1 is partly on the basis of a
false premise.  It appears that Microsoft's recent declaration of SMB1
as 'bad' is as much on the basis of coding flaws in their own SMB1
implementation as the lack of protection.  It is hoped that more modern
code might have less buffer-overflow style security flaws compared with
the 25 year old stuff.

Both however are good reasons to move off the SMB1 protocol towards
SMB3 on the server, and this is easiest and safest to do once the
clients also move to SMB3 by default.

Andrew Bartlett
-- 
Andrew Bartlett
https://samba.org/~abartlet/
Authentication Developer, Samba Team         https://samba.org
Samba Development and Support, Catalyst IT   
https://catalyst.net.nz/services/samba
