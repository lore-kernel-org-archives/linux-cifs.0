From: David Laight <david@l8s.co.uk>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Wed, 12 Dec 2012 08:34:01 +0000
Message-ID: <20121212083401.GW5010@snowdrop.l8s.co.uk>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121207161602.GA17710@infradead.org>
	<495d17310e0a687d446afc86def0f058@office.etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	wine-devel@winehq.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
To: Pavel Shilovsky <piastry@etersoft.ru>
Return-path: <wine-devel-bounces@winehq.org>
Content-Disposition: inline
In-Reply-To: <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
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

On Sat, Dec 08, 2012 at 12:43:14AM +0400, Pavel Shilovsky wrote:
> 
> The problem is the possibility of denial-of-service attacks here. We 
> can try to prevent them by:

FWIW I already see a DoS 'attack'.
I have some filestore shared using NFS (to Linux and Solaris) and 
using samba (to Windows).

I use it for release builds of a product to ensure the versions
built for the different operating systems match, and because some
files have to be built on an 'alien' system (eg gcc targetted at
embedded card).

I can't run the windows build at the same time as the others
because the windows C compiler manages to obtain exclusive access
to the source files - stopping the other systems from reading them.

	David

-- 
David Laight: david@l8s.co.uk
