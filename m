From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.13 28/43] SMB3: Validate negotiate request must always
 be signed
Date: Thu, 22 Mar 2018 11:32:33 +0100
Message-ID: <20180322103233.GA10695@kroah.com>
References: <6bca5a97-f581-86b8-12ad-77147619d519@csail.mit.edu>
 <CAH2r5mt91WGHDk-+LP4EBTEfAOmrY2k6_X7KKjc0D+LcDCfxRw@mail.gmail.com>
 <309db6c4-7e21-bfbe-44d4-eb41f5516d5e@csail.mit.edu>
 <CAH2r5muUfsZsqaBqkAfi_dXRheib+7DN=VSsbGcV22C2MdJaGw@mail.gmail.com>
 <20180313092133.GA13325@kroah.com>
 <CAH2r5mvmiTaC4W=LAaOvWv6xGEMce957c+u+Af6wNgxudbO3_w@mail.gmail.com>
 <20180316133241.GC11397@kroah.com>
 <CAH2r5mvYxpr_0CPZNiNJTGhFNaM06w-EoTT7WS8oVjVZq8HCCw@mail.gmail.com>
 <6745f869-e249-a891-8d76-79f2830dd57f@csail.mit.edu>
 <46a98623-2125-1f16-c456-db06f015f95a@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>,
        Thomas Backlund <tmb@mageia.org>,
        =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46a98623-2125-1f16-c456-db06f015f95a@csail.mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Mar 21, 2018 at 10:15:51PM -0700, Srivatsa S. Bhat wrote:
> On 3/21/18 10:12 PM, Srivatsa S. Bhat wrote:
> > On 3/21/18 7:02 PM, Steve French wrote:
> >> Found a patch which solves the dependency issue.  In my testing (on
> >> 4.9, with Windows 2016, and also to Samba) as Pavel suggested this
> >> appears to fix the problem, but I will let Srivatsa confirm that it
> >> also fixes it for him.  The two attached patches for 4.9 should work.
> >>
> > 
> > Indeed, those two patches fix the problem for me on 4.9. Thanks a lot
> > Steve, Pavel and Aurelien for all your efforts in fixing this!
> > 
> > I was also interested in getting this fixed on 4.4, so I modified the
> > patches to apply on 4.4.88 and verified that they fix the mount
> 
> I meant to say 4.4.122 there (the latest stable 4.4 version at the moment).

Thanks for these, all now queued up.

greg k-h
