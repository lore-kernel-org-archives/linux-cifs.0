From: Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v1] cifs: use server timestamp for ntlmv2 authentication
Date: Mon, 21 Sep 2015 21:06:24 +0200
Message-ID: <20150921210624.1fa14038@gmx.net>
References: <1442518812-30494-1-git-send-email-ps.report@gmx.net>
	<CAH2r5mu7Xb1zYyrgxWsq3yYDjtAT3H5zWvhA2V4RLj-tfGpv+A@mail.gmail.com>
	<CAH2r5mswDTGSKi2kN1wr7VNo3gpSM8FC_yekWOoYeZocDjN=DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mswDTGSKi2kN1wr7VNo3gpSM8FC_yekWOoYeZocDjN=DQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hello Steve,

On Thu, 17 Sep 2015 22:49:54 -0500, Steve French <smfrench@gmail.com> wrote:

> Corrected endian error and repushed
> 
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=patch;h=79a5296f14b26ac8644239286ffd7a62dbbc385e
> 

Many thanks for fixing the endianissue (next time I will try out your
sparse compile hint)...

Regards,
Peter


> On Thu, Sep 17, 2015 at 6:41 PM, Steve French <smfrench@gmail.com> wrote:
> > Nice catch.
> >
> > Merged into cifs-2.6.git for-next
> 
> 
> 
> 
