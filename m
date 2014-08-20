From: David Disseldorp <ddiss@suse.de>
Subject: Re: CIFS module build verification system
Date: Wed, 20 Aug 2014 11:20:04 +0200
Message-ID: <20140820112004.66b760fc@plati.site>
References: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog@mail.gmail.com>
	<CAKywueTMGq3tmf5fo5aWPUA888TgiKWHyRH=hQxHjRQ3in5gUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, Steve French <smfrench@gmail.com>
To: Pavel Shilovsky <pshilovsky@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAKywueTMGq3tmf5fo5aWPUA888TgiKWHyRH=hQxHjRQ3in5gUQ@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 20 Aug 2014 11:32:59 +0400, Pavel Shilovsky wrote:

...
> > The git repo for build verification system scripts:
> > http://git.altlinux.org/people/piastry/public/?p=cifs-tests.git;a=summary
> >
> > The git repo for patched Cthon tests (merged by Steve Dickson into his tree):
> > http://git.altlinux.org/people/piastry/public/?p=cthon04.git;a=summary
> >
> > The git repo for patched XFS tests:
> > http://git.altlinux.org/people/piastry/public/?p=xfstests.git;a=summary
> 
> Hi Steve, David,
> 
> Thank you for your notes and suggestions!
> 
> Do you understand right that I can squash David's commit (started with
> "SQUASH") into my patch?

Sure, go for it.

> Not sure about group file. CIFS (as NFS) doesn't have it's own tests
> now. Do you mean to add "test/cifs" directory with an empty (except a
> commented header) group file inside (to let us add cifs specific tests
> in future)?

My mistake, I thought the generic tests could be regrouped
per-filesystem. An empty template would be fine.

Cheers, David
