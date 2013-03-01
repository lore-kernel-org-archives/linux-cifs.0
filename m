From: David Laight <david@l8s.co.uk>
Subject: Re: [PATCH v3 0/7] Add O_DENY* support for VFS and CIFS/NFS
Date: Fri, 1 Mar 2013 08:17:29 +0000
Message-ID: <20130301081729.GT5181@snowdrop.l8s.co.uk>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
	<512FD1D5.3010106@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	wine-devel@winehq.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Pavel Shilovsky <piastry@etersoft.ru>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <wine-devel-bounces@winehq.org>
Content-Disposition: inline
In-Reply-To: <512FD1D5.3010106@mit.edu>
List-Unsubscribe: <http://www.winehq.org/mailman/options/wine-devel>,
	<mailto:wine-devel-request@winehq.org?subject=unsubscribe>
List-Archive: <http://www.winehq.org/pipermail/wine-devel>
List-Post: <mailto:wine-devel@winehq.org>
List-Help: <mailto:wine-devel-request@winehq.org?subject=help>
List-Subscribe: <http://www.winehq.org/mailman/listinfo/wine-devel>,
	<mailto:wine-devel-request@winehq.org?subject=subscribe>
Sender: wine-devel-bounces@winehq.org
Errors-To: wine-devel-bounces@winehq.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Feb 28, 2013 at 01:53:25PM -0800, Andy Lutomirski wrote:
> > O_DENYMAND - to switch on/off three flags above.
> 
> O_DENYMAND doesn't deny anything.  Would a name like O_RESPECT_DENY be
> better?

Possibly rename to O_CHECK_DENY ?

	David

-- 
David Laight: david@l8s.co.uk
