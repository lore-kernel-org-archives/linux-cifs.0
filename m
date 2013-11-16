From: steve <steve@steve-ss.com>
Subject: Re: setfacl fix
Date: Sat, 16 Nov 2013 16:15:25 +0100
Message-ID: <1384614925.3216.6.camel@hh16.hh3.site>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
	 <20131116145507.GA22395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, samba-technical <samba-technical@lists.samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20131116145507.GA22395@infradead.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org


> > From: Steve French <smfrench@gmail.com>
> > Date: Fri, 15 Nov 2013 20:41:32 -0600
> > Subject: [PATCH] [CIFS] setfacl removes part of ACL when setting POSIX ACLs to
> >  Samba
> > 
> > setfacl over cifs mounts can remove the default ACL 

Hi
cifs-utils 6.1 Samba 4.1.0

I don't understand the '...over cifs mounts...' bit.

Does it mean that if I have a share mounted on my Linux box and do a
setfacl on a file in the share then the default acl will be removed?

Sorry for a non dev question.

Cheers,
Steve
