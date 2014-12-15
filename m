From: David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH 2/2] cifs: add server-side copy sanity test
Date: Mon, 15 Dec 2014 11:04:31 +0100
Message-ID: <20141215110431.65c8bd80@plati.site>
References: <1418170485-3732-1-git-send-email-ddiss@suse.de>
	<1418170485-3732-2-git-send-email-ddiss@suse.de>
	<CAHse=S91DYDaevHeFa51k2PAgHzoWO68QmGZrC7RNQ4Dm1Pojw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, linux-cifs@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAHse=S91DYDaevHeFa51k2PAgHzoWO68QmGZrC7RNQ4Dm1Pojw@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 15 Dec 2014 09:31:57 +0000, David Drysdale wrote:

> > This test uses the cloner binary to issue CIFS_IOC_COPYCHUNK_FILE
> > server-side copy requests.
> >
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >  tests/cifs/001     | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/cifs/001.out | 21 +++++++++++++++++
> >  tests/cifs/group   |  6 +++++
> >  3 files changed, 96 insertions(+)
> >  create mode 100755 tests/cifs/001
> >  create mode 100644 tests/cifs/001.out
> >  create mode 100644 tests/cifs/group  
> 
> Does this also need a new tests/cifs/Makefile (so that e.g. the install
> target in tests/Makefile still works)?

Yes, you're right. Thanks for the feedback. I'll send through a new
version with the Makefile.

Cheers, David
