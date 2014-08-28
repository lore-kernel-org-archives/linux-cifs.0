From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH v2 3/3] cifs: skip tests that need POSIX support for
 nounix mounts
Date: Thu, 28 Aug 2014 11:25:22 +0400
Message-ID: <CAKywueRrvG7J7ff+CeX=J6-94xRSo47gKTdBHU0b28XEich5ag@mail.gmail.com>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org> <1409084918-17764-4-git-send-email-pshilovsky@samba.org> <20140827155832.GA3103@infradead.org>
	<2DA51A6D-2D91-4582-831B-23C997C37543@gmail.com> <20140827225047.GA4239@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>, David Disseldorp <ddiss@suse.de>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>, "samba-technical@samba.org" <samba-technical@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20140827225047.GA4239@infradead.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

2014-08-28 2:50 GMT+04:00 Christoph Hellwig <hch@infradead.org>:
> On Wed, Aug 27, 2014 at 11:49:56PM +0400, Pavel Shilovsky wrote:
>> So for these tests we need two check functions: _require_symlink for 005,
>> 023, 024, 025 and _require_fcntl for 131. Right?
>
> More or less. I'd call the second one _require_fcntl_locks as fcntl
> is a multiplexer for tons of unrelated functionality.

Ok, let's name it this way.

What's about the 1st and 2nd patches? I am going to repost the series
with a new version of the 3rd patch (according to our discussion) and
it'll be better to incorporate their possible changes as well.

-- 
Best regards,
Pavel Shilovsky.
