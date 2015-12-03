From: Christoph Hellwig <hch@lst.de>
Subject: Re: vfs: move btrfs clone ioctls to common code
Date: Thu, 3 Dec 2015 11:30:35 +0100
Message-ID: <20151203103035.GA15996@lst.de>
References: <1448563859-21922-1-git-send-email-hch@lst.de> <CAH2r5muW6=v6tx3BwXSYMgn7EZgzVANniebsxfwpdq9Y=0VcuA@mail.gmail.com> <20151202072757.GB15839@lst.de> <CAH2r5msWk+oA=teWnLrpJhp48PEToMoWiN8H8+ptdvEko+GNbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Peng Tao <tao.peng@primarydata.com>,
	Jeffrey Layton <jeff.layton@primarydata.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msWk+oA=teWnLrpJhp48PEToMoWiN8H8+ptdvEko+GNbA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Dec 02, 2015 at 11:40:13AM -0600, Steve French wrote:
> If the copy_file_range is allowed to use any offload mechanism then
> cifs.ko could be changed as follows, to fallback among the three
> possible mechanisms depending on what the target supports.

How reliable are the fallbacks?  E.g. for clones we usually have alignment
restrictions that we'd need to communicate back, and cifs currently
doesn't have client side checks for those.
