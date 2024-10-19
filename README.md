# Wits - Proof-of-Creativity Platform

A decentralized platform for verifying and authenticating original creative works using the Stacks blockchain. This platform enables creators to submit their work for community validation and receive NFT certificates of authenticity.

## Overview

The Proof-of-Creativity platform provides a decentralized solution for:
- Registering original creative works on-chain
- Community-driven validation of creativity and originality
- Minting NFT certificates for verified works
- Incentivizing honest validation through reputation and rewards

## Smart Contract Architecture

### Core Components

1. **Submission System**
    - Creators submit content hashes of their work
    - Each submission receives a unique identifier
    - Submissions track validation status and vote counts

2. **Validation Mechanism**
    - Community validators vote on originality
    - Voting period: ~1 day (144 blocks)
    - Minimum required votes: 3
    - One vote per validator per submission

3. **NFT Certification**
    - Successful validations receive a Proof-of-Creativity NFT
    - Each NFT has a unique identifier
    - NFTs are non-transferable proof of validation

4. **Validator Incentives**
    - Reputation scoring system
    - Rewards for active participation
    - Transparent validation history

## Function Reference

### Public Functions

```clarity
(submit-work (content-hash (buff 32)))
```
Submit a new creative work for validation.
- Parameters:
    - `content-hash`: 32-byte hash of the creative work
- Returns: Submission ID or error

```clarity
(vote (submission-id uint) (is-positive bool))
```
Vote on a submission's creativity/originality.
- Parameters:
    - `submission-id`: ID of the submission
    - `is-positive`: true for positive vote, false for negative
- Returns: Success/failure status

```clarity
(finalize-validation (submission-id uint))
```
Finalize validation and mint NFT if criteria are met.
- Parameters:
    - `submission-id`: ID of the submission
- Returns: Success/failure status

### Read-Only Functions

```clarity
(get-submission (submission-id uint))
```
Get details of a specific submission.

```clarity
(get-validator-score (validator principal))
```
Get reputation score for a validator.

```clarity
(get-total-submissions)
```
Get total number of submissions.

```clarity
(get-total-nfts)
```
Get total number of minted NFTs.

## Error Codes

| Code | Description |
|------|-------------|
| 100  | Not contract owner |
| 101  | Work already submitted |
| 102  | Submission not found |
| 103  | Already voted |
| 104  | Voting period closed |
| 105  | Insufficient votes |

## Setup and Deployment

1. Install Clarinet:
```bash
curl -L https://github.com/hirosystems/clarinet/releases/download/v1.5.4/clarinet-linux-x64.tar.gz | tar xz
sudo mv clarinet /usr/local/bin
```

2. Initialize project:
```bash
clarinet new proof-of-creativity
cd proof-of-creativity
```

3. Deploy contract:
```bash
clarinet deploy
```

## Testing

Run the test suite:
```bash
clarinet test
```

## Security Considerations

1. **Content Hash Verification**
    - Users should verify content hashes before submission
    - Use consistent hashing algorithm (SHA-256 recommended)

2. **Validation Period**
    - Fixed timeframe prevents vote manipulation
    - Minimum vote threshold ensures consensus

3. **Vote Manipulation Prevention**
    - One vote per validator per submission
    - Reputation system discourages malicious behavior

## Future Enhancements

1. **Governance System**
    - Token-based voting on platform parameters
    - Community-driven feature proposals

2. **Enhanced Validation**
    - Multi-stage validation process
    - Specialized validator categories
    - Stake-based voting weight

3. **Metadata Storage**
    - Extended work metadata
    - Category-specific attributes
    - Rich media support

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions and support, please open an issue in the repository.

---
Built with ❤️ on Stacks
