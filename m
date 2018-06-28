From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: config files and how to have persistent Linux kernel Driver/File
 System configuration info saved
Date: Thu, 28 Jun 2018 18:58:57 -0400
Message-ID: <20180628225857.GB1231@thunk.org>
References: <CAH2r5msV1hBAGgqtMFh6P=OGPV3RKjVAER=5bg-6Y+vW5BEJwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msV1hBAGgqtMFh6P=OGPV3RKjVAER=5bg-6Y+vW5BEJwQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Jun 28, 2018 at 05:37:15PM -0500, Steve French wrote:
> Ronnie brought up an interesting point about the problems consistently
> configuring file systems (or any Linux module for that matter) so that
> reboot doesn't wipe away security or performance tuning changes.

In general it's considered best practice to make the file system
auto-tune itself as much as possible, because the sad fact is that
99.9999% of the customers aren't going to bother to add any tuning
parameters.  So there hasn't been a push to try to create something
more complex, because it's generally not needed.

Settings via /sys/fs/ext4 are generally for developers as they try to
understand how things work, so they can improve the file systems
defaults / auto-tuning algorithms.

						- Ted
