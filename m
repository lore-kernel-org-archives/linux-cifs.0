From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.13 28/43] SMB3: Validate negotiate request must always
 be signed
Date: Tue, 13 Mar 2018 10:21:33 +0100
Message-ID: <20180313092133.GA13325@kroah.com>
References: <20171101151803.GB31285@kroah.com>
 <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu>
 <28ffc363-5140-5685-d288-6e3dc07c6369@csail.mit.edu>
 <20180227085428.GA16879@kroah.com>
 <b20cbd94-ce9b-cb2c-dc95-a6821376823f@csail.mit.edu>
 <20180227124050.GB31888@kroah.com>
 <6bca5a97-f581-86b8-12ad-77147619d519@csail.mit.edu>
 <CAH2r5mt91WGHDk-+LP4EBTEfAOmrY2k6_X7KKjc0D+LcDCfxRw@mail.gmail.com>
 <309db6c4-7e21-bfbe-44d4-eb41f5516d5e@csail.mit.edu>
 <CAH2r5muUfsZsqaBqkAfi_dXRheib+7DN=VSsbGcV22C2MdJaGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Thomas Backlund <tmb@mageia.org>,
        =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muUfsZsqaBqkAfi_dXRheib+7DN=VSsbGcV22C2MdJaGw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Mar 11, 2018 at 07:37:55PM -0700, Steve French wrote:
> Just got a wireshark trace - this is a fairly trivial issue (missing
> the validate negotiate must be signed patch) - I had some trouble
> getting this version of the kernel running (unrelated issue) and on
> systems with access to Windows 2016...

Ok, I have no idea what this means, or what I should do here because of
it :(

Any hints for what to do with the stable tree?

totally confused,

greg k-h
