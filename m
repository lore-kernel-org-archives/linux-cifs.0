From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] fs: remove obsolete simple_strto<foo>
Date: Thu, 13 Dec 2012 14:33:11 +1100
Message-ID: <20121213033311.GG16353@dastard>
References: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
	Ron Minnich <rminnich@sandia.gov>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Chris Mason <chris.mason@fusionio.com>,
	Steve French <sfrench@samba.org>,
	Christine Caulfield <ccaulfie@redhat.com>,
	David Teigland <teigland@redhat.com>, Ben Myers <bpm@sgi.com>,
	Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
	v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, cluster-devel@redhat.com
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Dec 07, 2012 at 05:25:19PM +0530, Abhijit Pawar wrote:
> This patch replace the obsolete simple_strto<foo> with kstrto<foo>

The XFS changes look fine. Consider those:

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
